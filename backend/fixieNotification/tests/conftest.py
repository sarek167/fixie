import sys
import importlib
import pytest
import types

@pytest.fixture(autouse=True)
def _channels_inmemory(settings):
    settings.CHANNEL_LAYERS = {
        "default": {"BACKEND": "channels.layers.InMemoryChannelLayer"}
    }

@pytest.fixture
def user_id():
    return 123

@pytest.fixture
def consumer_cls(monkeypatch, user_id):
    """
    Patching dekoratora jwt_required_ws ZANIM zaimportujemy moduł z consumerem.
    Dekorator ustawia self.user_id i przepuszcza dalej.
    """
    def fake_jwt_required_ws(func):
        async def wrapper(self, *args, **kwargs):
            self.user_id = user_id
            return await func(self, *args, **kwargs)
        return wrapper

    monkeypatch.setattr("utils.decorators.jwt_required_ws", fake_jwt_required_ws, raising=False)

    for mod in list(sys.modules):
        if mod.endswith(".consumer") or mod.endswith(".consumers"):
            sys.modules.pop(mod, None)

    consumer_module = importlib.import_module("notification_management.consumer")
    importlib.reload(consumer_module)
    return consumer_module.NotificationConsumer

@pytest.fixture
def fake_kafka(monkeypatch):
    """Wstrzykuje moduł 'kafka' z atrapą KafkaConsumer (jedna wiadomość)."""
    class OneShotKafkaConsumer:
        def __init__(self, *a, **k):
            self._it = iter([types.SimpleNamespace(
                topic="reward-granted",
                value={"user_id": 42, "title": "T", "message": "M", "container_name": "C", "blob_name": "B"},
            )])
        def __iter__(self):
            return self._it

    fake_mod = types.SimpleNamespace(KafkaConsumer=OneShotKafkaConsumer)
    monkeypatch.setitem(sys.modules, "kafka", fake_mod)
    return fake_mod

@pytest.fixture
def channel_sent(monkeypatch):
    """Patchuje channels.layers.get_channel_layer tak, by zwracał nasz stub z group_send."""
    import channels.layers as ch_layers
    sent = []

    async def fake_group_send(group, event):
        sent.append((group, event))

    chan = types.SimpleNamespace(group_send=fake_group_send)
    monkeypatch.setattr(ch_layers, "get_channel_layer", lambda: chan, raising=True)
    return sent

@pytest.fixture
def fresh_command_import():
    import sys
    for name in list(sys.modules):
        if (
            name.endswith(".run_notification_worker")
            or name.endswith("commands.run_notification_worker")
        ):
            sys.modules.pop(name, None)