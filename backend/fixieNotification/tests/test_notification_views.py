import json
import pytest
from asgiref.sync import sync_to_async
from channels.testing import WebsocketCommunicator
from django.utils import timezone
from notification_management.models import Notification
from channels.layers import get_channel_layer
from hypothesis import given, strategies as st
from freezegun import freeze_time
from django.core.management import call_command
from datetime import timedelta
import importlib
import types
import sys
import asyncio

pytestmark = [pytest.mark.django_db(transaction=True)]

async def _wait_delivered(obj, timeout=0.3):
    deadline = asyncio.get_event_loop().time() + timeout
    while asyncio.get_event_loop().time() < deadline:
        await sync_to_async(obj.refresh_from_db)()
        if obj.delivered:
            return True
        await asyncio.sleep(0.01)
    return False

@pytest.mark.asyncio
async def test_connect_sends_pending_and_marks_delivered(consumer_cls, user_id):
    payloads = [
        {"title": "A", "message": "a"},
        {"title": "B", "message": "b"},
    ]

    n1 = await sync_to_async(Notification.objects.create)(
        user_id=user_id, payload=payloads[0], delivered=False
    )
    n2 = await sync_to_async(Notification.objects.create)(
        user_id=user_id, payload=payloads[1], delivered=False
    )
    await sync_to_async(Notification.objects.create)(
        user_id=user_id, payload={"title": "C"}, delivered=True, delivered_at=timezone.now()
    )

    communicator = WebsocketCommunicator(consumer_cls.as_asgi(), "/ws/notifications/")
    connected, _ = await communicator.connect()
    assert connected is True

    msgs = []
    for _ in range(2):
        raw = await communicator.receive_from()
        data = json.loads(raw)
        msgs.append(data)

    for m, expected in zip(msgs, payloads):
        for k, v in expected.items():
            assert m[k] == v

    await sync_to_async(n1.refresh_from_db)()
    await sync_to_async(n2.refresh_from_db)()
    assert n1.delivered is False and n2.delivered is False

    for m in msgs:
        await communicator.send_to(text_data=json.dumps({
            "type": "ack",
            "notification_id": m["notification_id"],
        }))

    assert await _wait_delivered(n1)
    assert await _wait_delivered(n2)    

    
    await sync_to_async(n1.refresh_from_db)()
    await sync_to_async(n2.refresh_from_db)()
    assert n1.delivered and n1.delivered_at is not None
    assert n2.delivered and n2.delivered_at is not None

@pytest.mark.asyncio
async def test_group_send_triggers_send_notification(consumer_cls, user_id):
    communicator = WebsocketCommunicator(consumer_cls.as_asgi(), "/ws/notifications/")
    connected, _ = await communicator.connect()
    assert connected

    channel_layer = get_channel_layer()

    event = {
        "type": "send_notification",
        "title": "Hello",
        "message": "World",
        "container_name": "c",
        "blob_name": "b",
        "notification_id": 999,
    }
    await channel_layer.group_send(f"user_{user_id}", event)

    out = json.loads(await communicator.receive_from())
    assert out == {
        "title": "Hello",
        "message": "World",
        "container_name": "c",
        "blob_name": "b",
        "notification_id": 999,
    }
    await communicator.disconnect()


@given(
    st.dictionaries(
        keys=st.sampled_from(["title", "message", "container_name", "blob_name"]),
        values=st.text(min_size=0, max_size=20),
        min_size=0,
        max_size=4,
    )
)
@pytest.mark.asyncio
async def test_send_notification_shapes_payload(event):
    from notification_management.consumer import NotificationConsumer

    consumer = NotificationConsumer(scope={"type": "websocket"})
    sent = {}

    async def fake_send(*, text_data=None, bytes_data=None):
        sent.update(json.loads(text_data))

    consumer.send = fake_send

    payload = {"type": "send_notification", **event}
    await consumer.send_notification(payload)

    assert set(sent.keys()) == {"title", "message", "container_name", "blob_name", "notification_id"}
    for k in ["title", "message", "container_name", "blob_name"]:
        assert sent[k] == event.get(k)
    assert sent["notification_id"] == event.get("notification_id")


def test_cleanup_notifications_deletes_expected(capsys):
    now = timezone.now()
    with freeze_time(now):

        old_read = Notification.objects.create(user_id=1, payload={}, delivered=True, delivered_at=now - timedelta(days=8))

        fresh_read = Notification.objects.create(user_id=1, payload={}, delivered=True, delivered_at=now - timedelta(days=3))

        very_old_unread = Notification.objects.create(user_id=1, payload={}, delivered=False)
        Notification.objects.filter(pk=very_old_unread.pk).update(created_at=now - timedelta(days=181))

        fresh_unread = Notification.objects.create(user_id=1, payload={}, delivered=False)
        Notification.objects.filter(pk=fresh_unread.pk).update(created_at=now - timedelta(days=10))

        call_command("clear_old_notifications")

    captured = capsys.readouterr().out

    assert "Deleted 1 read and 1 unread notifications." in captured

    ids = set(Notification.objects.values_list("id", flat=True))
    assert set(ids) == {fresh_read.id, fresh_unread.id}

@pytest.mark.usefixtures("fake_kafka", "fresh_command_import")
@pytest.mark.django_db(transaction=True)
def test_kafka_worker_happy_path(monkeypatch, channel_sent):
    Notification.objects.all().delete()
    uid = 4242

    mod = importlib.import_module(
        "notification_management.management.commands.run_notification_worker"
    )

    class OneShotKafkaConsumer:
        def __init__(self, *a, **k):
            self._it = iter([types.SimpleNamespace(
                topic="reward-granted",
                value={"user_id": uid, "title": "T", "message": "M",
                       "container_name": "C", "blob_name": "B"},
            )])
        def __iter__(self): return self._it

    async def noop_group_send(group, event):
        pass

    chan = types.SimpleNamespace(group_send=noop_group_send)

    monkeypatch.setattr(mod, "KafkaConsumer", OneShotKafkaConsumer, raising=True)
    monkeypatch.setattr(mod, "get_channel_layer", lambda: chan, raising=True)

    call_command("run_notification_worker")

    qs = Notification.objects.filter(user_id=uid)
    assert qs.count() == 1, f"Expect 1, got {qs.count()}"
    n = qs.get()
    assert n.delivered is False and n.delivered_at is None

@pytest.mark.usefixtures("fresh_command_import")
def test_kafka_worker_fallback_to_db_when_error(monkeypatch):
    import sys, types
    class OneShotKafkaConsumer:
        def __init__(self, *a, **k):
            self._it = iter([types.SimpleNamespace(
                topic="reward-granted",
                value={"user_id": 42, "title": "T", "message": "M", "container_name": "C", "blob_name": "B"},
            )])
        def __iter__(self): return self._it
    monkeypatch.setitem(sys.modules, "kafka", types.SimpleNamespace(KafkaConsumer=OneShotKafkaConsumer))

    import channels.layers as ch_layers
    async def failing_group_send(group, event):
        raise RuntimeError("no channel layer")
    chan = types.SimpleNamespace(group_send=failing_group_send)
    monkeypatch.setattr(ch_layers, "get_channel_layer", lambda: chan, raising=True)

    call_command("run_notification_worker")

    n = Notification.objects.get(user_id=42)
    assert n.delivered is False and n.delivered_at is None

@pytest.mark.usefixtures("fresh_command_import")
def test_kafka_worker_skips_when_missing_user_id(monkeypatch):
    Notification.objects.all().delete()

    class NoUserIdKafkaConsumer:
        def __init__(self, *a, **k):
            self._it = iter([types.SimpleNamespace(
                topic="reward-granted", value={"title": "X"}
            )])
        def __iter__(self): return self._it
    monkeypatch.setitem(sys.modules, "kafka", types.SimpleNamespace(KafkaConsumer=NoUserIdKafkaConsumer))

    import channels.layers as ch_layers
    async def noop_group_send(group, event): pass
    chan = types.SimpleNamespace(group_send=noop_group_send)
    monkeypatch.setattr(ch_layers, "get_channel_layer", lambda: chan, raising=True)

    call_command("run_notification_worker")

    assert Notification.objects.count() == 0