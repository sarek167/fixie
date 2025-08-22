import json
import pytest
from unittest.mock import MagicMock, patch
from hypothesis import given, settings as hy_settings, strategies as st


from django.test import RequestFactory
from rest_framework.test import APIRequestFactory

from avatar_management.models import Colors, Reward, UserReward, AvatarState
from avatar_management.views import UserAvatarElementsView, AvatarStateView


@pytest.fixture
def rf():
    return RequestFactory()

@pytest.fixture
def apirf():
    return APIRequestFactory()

@pytest.fixture
def colors():
    red  = Colors.objects.create(name="Red",  hex="#ff0000")
    blue = Colors.objects.create(name="Blue", hex="#0000ff")
    return red, blue

@pytest.fixture
def rewards(colors):
    red, blue = colors
    r1 = Reward.objects.create(
        blob_name="eyes_1", container_name="eyes", starter=True,
        trigger_type=None, trigger_value=None, color=blue
    )
    r2 = Reward.objects.create(
        blob_name="hair_1", container_name="hair", starter=True,
        trigger_type=None, trigger_value=None, color=red
    )
    r3 = Reward.objects.create(
        blob_name="top_1", container_name="top_clothes", starter=False,
        trigger_type="task_completion", trigger_value=1, color=red
    )
    return r1, r2, r3

@pytest.fixture
def user_reward(rewards):
    _, _, r3 = rewards
    return UserReward.objects.create(reward=r3, user_id=123)

@pytest.mark.django_db
def test_elements_groups_starter_and_owned(rf, rewards, user_reward, monkeypatch):
    def _fake_reward_serializer(obj, *a, **k):
        class _S:
            @property
            def data(self):
                return {
                    "blob_name": obj.blob_name,
                    "container_name": obj.container_name,
                    "color_to_display": getattr(obj, "color_to_display", None),
                }
        return _S()
    monkeypatch.setattr("avatar_management.views.RewardSerializer", _fake_reward_serializer)

    req = rf.get("/api/avatar/elements")
    req.user_id = 123

    resp = UserAvatarElementsView().get(req)
    assert resp.status_code == 200
    payload = json.loads(resp.content)

    assert "eyes" in payload and "hair" in payload and "top_clothes" in payload
    assert any(x["blob_name"] == "eyes_1" for x in payload["eyes"])
    assert any(x["blob_name"] == "hair_1" for x in payload["hair"])
    assert any(x["blob_name"] == "top_1" for x in payload["top_clothes"])

@pytest.mark.django_db
def test_elements_empty_when_no_starters_and_no_user_rewards(rf, monkeypatch):
    monkeypatch.setattr(
        "avatar_management.views.RewardSerializer",
        lambda obj, *a, **k: type("S", (), {"data": {}})()
    )
    req = rf.get("/api/avatar/elements")
    req.user_id = 999

    resp = UserAvatarElementsView().get(req)
    assert resp.status_code == 200
    assert json.loads(resp.content) == {}

@pytest.mark.django_db
def test_avatar_state_get_found(rf, monkeypatch):
    AvatarState.objects.create(
        user_id=12, skin_color="light", eyes_color="blue",
        hair="short", hair_color="brown",
        top_clothes="tshirt", top_clothes_color="white",
        bottom_clothes="jeans", bottom_clothes_color="blue",
        beard="none", lipstick="0", blush="0",
    )

    class _FakeSerializer:
        def __init__(self, obj): self._obj = obj
        @property
        def data(self): return {"user_id": self._obj.user_id, "skin_color": self._obj.skin_color}

    monkeypatch.setattr("avatar_management.views.AvatarStateSerializer", _FakeSerializer)

    req = rf.get("/api/avatar/state")
    req.user_id = 12

    resp = AvatarStateView().get(req)
    assert resp.status_code == 200
    assert json.loads(resp.content) == {"user_id": 12, "skin_color": "light"}

@pytest.mark.django_db
def test_avatar_state_get_not_found(rf):
    req = rf.get("/api/avatar/state")
    req.user_id = 777
    resp = AvatarStateView().get(req)
    assert resp.status_code == 204
    assert json.loads(resp.content) == {"status": "Avatar state not found."}

_str20  = st.text(min_size=0, max_size=20)
_str50  = st.text(min_size=0, max_size=50)
avatar_payload_strategy = st.fixed_dictionaries({
    "skin_color": _str20,
    "eyes_color": _str20,
    "hair": _str50,
    "hair_color": _str20,
    "top_clothes": _str50,
    "top_clothes_color": _str20,
    "bottom_clothes": _str50,
    "bottom_clothes_color": _str20,
    "beard": _str50,
})


@hy_settings(deadline=None, max_examples=25)
@given(payload=avatar_payload_strategy)
@pytest.mark.django_db
def test_avatar_state_put_enqueues_and_sets_user_id(payload):
    rf = RequestFactory()
    fake_producer = MagicMock()

    with patch("avatar_management.views.producer", fake_producer):
        req = rf.put("/api/avatar/state", data=json.dumps(payload), content_type="application/json")
        req.user_id = 42
        req.data = payload.copy()

        resp = AvatarStateView().put(req)
        assert resp.status_code == 202
        assert json.loads(resp.content) == {"status": "update enqueued"}

        fake_producer.send.assert_called_once()
        topic, sent_payload = fake_producer.send.call_args.args
        assert topic == "avatar-updates"
        assert sent_payload["user_id"] == 42
        for k, v in payload.items():
            assert sent_payload[k] == v

@pytest.mark.django_db
def test_avatar_state_put_passes_through_extra_fields(rf, monkeypatch):
    fake_producer = MagicMock()
    monkeypatch.setattr("avatar_management.views.producer", fake_producer, raising=True)

    payload = {"foo": "bar"}
    req = rf.put("/api/avatar/state", data=json.dumps(payload), content_type="application/json")
    req.user_id = 99
    req.data = payload.copy()

    resp = AvatarStateView().put(req)
    assert resp.status_code == 202
    topic, sent_payload = fake_producer.send.call_args.args
    assert topic == "avatar-updates"
    assert sent_payload["foo"] == "bar"
    assert sent_payload["user_id"] == 99

@pytest.mark.django_db
def test_jwt_required_rejects_missing_token_on_elements(apirf):
    view = UserAvatarElementsView.as_view()
    request = apirf.get("/api/avatar/elements")
    response = view(request)
    assert response.status_code == 401
    assert json.loads(response.content) == {"error": "Token not found"}

@pytest.mark.django_db
def test_jwt_required_rejects_invalid_token_on_state_get(apirf, monkeypatch):
    monkeypatch.setattr("utils.decorators.decode_jwt", lambda token: (_ for _ in ()).throw(ValueError("Incorrect token")))
    view = AvatarStateView.as_view()
    request = apirf.get("/api/avatar/state", HTTP_AUTHORIZATION="Bearer bad.token")
    response = view(request)
    assert response.status_code == 401
    assert json.loads(response.content) == {"error": "Incorrect token"}

@pytest.mark.django_db
def test_jwt_required_allows_valid_token_and_sets_user_id_on_elements(apirf, rewards, user_reward, monkeypatch):
    monkeypatch.setattr("utils.decorators.decode_jwt", lambda token: {"user_id": 321})

    def _fake_reward_serializer(obj, *a, **k):
        class _S:
            @property
            def data(self):
                return {"blob_name": obj.blob_name, "container_name": obj.container_name}
        return _S()
    monkeypatch.setattr("avatar_management.views.RewardSerializer", _fake_reward_serializer)

    view = UserAvatarElementsView.as_view()
    request = apirf.get("/api/avatar/elements", HTTP_AUTHORIZATION="Bearer good.token")
    response = view(request)
    assert response.status_code == 200
    data = json.loads(response.content)
    assert "eyes" in data and "hair" in data

@pytest.mark.django_db
def test_jwt_required_valid_token_on_state_put_overrides_user_id(apirf, monkeypatch):
    monkeypatch.setattr("utils.decorators.decode_jwt", lambda token: {"user_id": 777})
    fake_producer = MagicMock()
    monkeypatch.setattr("avatar_management.views.producer", fake_producer, raising=True)

    view = AvatarStateView.as_view()
    body = {"user_id": 1, "skin_color": "light"}
    request = apirf.put(
        "/api/avatar/state",
        data=json.dumps(body),
        content_type="application/json",
        HTTP_AUTHORIZATION="Bearer good.token"
    )
    response = view(request)
    assert response.status_code == 202
    fake_producer.send.assert_called_once()
    _, sent = fake_producer.send.call_args.args
    assert sent["user_id"] == 777
    assert sent["skin_color"] == "light"
