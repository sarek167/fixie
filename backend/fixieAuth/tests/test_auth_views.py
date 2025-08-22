import types
from unittest.mock import MagicMock, patch

import pytest
from hypothesis import given, settings, strategies as st
from rest_framework import status
from rest_framework.test import APIRequestFactory, force_authenticate

MODULE_VIEWS = "user_management.views"
MODULE_SERIALIZERS = "user_management.serializers"
MODULE_MODELS = "user_management.models"

# hypothesis strategies for generating test data
email_st = st.emails()
username_st = st.text(min_size=3, max_size=30).filter(lambda s: s.strip() != "")
password_st = st.text(min_size=8, max_size=40)

@pytest.fixture(scope="module")
def rf():
    return APIRequestFactory()

api_rf = APIRequestFactory()

def _mock_user(**overrides):
    user = MagicMock()
    user.id = overrides.get("id", 123)
    user.email = overrides.get("email", "john@example.com")
    user.username = overrides.get("username", "johnny")
    user.first_name = overrides.get("first_name", "")
    user.last_name = overrides.get("last_name", "")
    user.check_password = MagicMock(return_value=True)
    user.set_password = MagicMock()
    user.save = MagicMock()
    return user


class _FakeRefresh:
    def __init__(self, access="ACCESS123", refresh="REFRESH456"):
        self.access_token = access
        self._refresh = refresh
    def __str__(self):
        return self._refresh


@patch(f"{MODULE_VIEWS}.RefreshToken")
@patch(f"{MODULE_VIEWS}.RegisterSerializer")
def test_register_success(mock_reg_serializer, mock_refresh, rf):
    from user_management.views import RegisterView

    user = _mock_user(email="e@e.com", username="eu")
    serializer = MagicMock()
    serializer.is_valid.return_value = True
    serializer.save.return_value = user
    mock_reg_serializer.return_value = serializer

    fake = _FakeRefresh()
    mock_refresh.for_user.return_value = fake

    req = rf.post("/register", {"email": "e@e.com", "username": "eu", "password": "secret123"}, format="json")

    resp = RegisterView.register(req)

    assert resp.status_code == status.HTTP_201_CREATED
    body = resp.data
    assert body["id"] == user.id
    assert body["email"] == user.email
    assert body["username"] == user.username
    assert body["access_token"] == str(fake.access_token)
    assert body["refresh_token"] == str(fake)


@patch(f"{MODULE_VIEWS}.RegisterSerializer")
def test_register_invalid_returns_400(mock_reg_serializer, rf):
    from user_management.views import RegisterView

    serializer = MagicMock()
    serializer.is_valid.return_value = False
    serializer.errors = {"email": ["This field is required."]}
    mock_reg_serializer.return_value = serializer

    req = rf.post("/register", {"username": "u"}, format="json")
    resp = RegisterView.register(req)

    assert resp.status_code == status.HTTP_400_BAD_REQUEST
    assert "email" in resp.data


@settings(max_examples=10)
@given(email=email_st, username=username_st, password=password_st)
def test_register_success_property(email, username, password):
    from user_management.views import RegisterView

    user = _mock_user(email=email, username=username)

    with patch(f"{MODULE_VIEWS}.RegisterSerializer") as mock_reg, \
         patch(f"{MODULE_VIEWS}.RefreshToken") as mock_refresh:
        ser = MagicMock()
        ser.is_valid.return_value = True
        ser.save.return_value = user
        mock_reg.return_value = ser
        mock_refresh.for_user.return_value = _FakeRefresh()

        req = api_rf.post("/register",
                          {"email": email, "username": username, "password": password},
                          format="json")
        resp = RegisterView.register(req)

    assert resp.status_code == 201
    assert resp.data["email"] == email
    assert resp.data["username"] == username

@patch(f"{MODULE_VIEWS}.RefreshToken")
@patch(f"{MODULE_VIEWS}.LoginSerializer")
def test_login_success(mock_login_serializer, mock_refresh, rf):
    from user_management.views import LoginView

    user = _mock_user()
    serializer = MagicMock()
    serializer.is_valid.return_value = True
    serializer.verify.return_value = {"user": user}
    mock_login_serializer.return_value = serializer
    mock_refresh.for_user.return_value = _FakeRefresh()

    req = rf.post("/login", {"email": "e@e.com", "password": "secret123"}, format="json")
    resp = LoginView.login(req)

    assert resp.status_code == status.HTTP_200_OK
    assert resp.data["id"] == user.id
    assert "access_token" in resp.data
    assert "refresh_token" in resp.data


@patch(f"{MODULE_VIEWS}.LoginSerializer")
def test_login_invalid_returns_401(mock_login_serializer, rf):
    from user_management.views import LoginView

    serializer = MagicMock()
    serializer.is_valid.return_value = False
    mock_login_serializer.return_value = serializer

    req = rf.post("/login", {"email": "bad", "password": "x"}, format="json")
    resp = LoginView.login(req)

    assert resp.status_code == status.HTTP_401_UNAUTHORIZED
    assert resp.data["error"] == "Invalid credentials"


@patch(f"{MODULE_VIEWS}.JWTAuthentication")
@patch(f"{MODULE_VIEWS}.RefreshToken")
def test_logout_success(mock_refresh_class, mock_jwt_auth, rf):
    from user_management.views import LogoutView

    mock_user = _mock_user()
    mock_jwt_auth.return_value.authenticate.return_value = (mock_user, "access")

    token_instance = MagicMock()
    mock_refresh_class.return_value = token_instance
    view = LogoutView.as_view()
    req = rf.post("/logout", {"refresh_token": "REFRESH456"}, format="json")
    resp = view(req)

    assert resp.status_code == status.HTTP_200_OK
    token_instance.blacklist.assert_called_once()


@patch(f"{MODULE_VIEWS}.JWTAuthentication")
def test_logout_missing_token_returns_401(mock_jwt_auth, rf):
    from user_management.views import LogoutView
    mock_user = _mock_user()
    mock_user['refresh_token'] = None
    mock_jwt_auth.return_value.authenticate.return_value = (mock_user, "access")

    view = LogoutView.as_view()
    req = rf.post("/logout", {}, format="json")
    resp = view(req)

    assert resp.status_code == status.HTTP_401_UNAUTHORIZED
    assert resp.data["error"] == "Invalid token"


@patch(f"{MODULE_VIEWS}.JWTAuthentication")
@patch(f"{MODULE_VIEWS}.RefreshToken")
def test_logout_invalid_token_returns_401(mock_refresh_class, mock_jwt_auth, rf):
    from user_management.views import LogoutView
    mock_user = _mock_user()
    mock_jwt_auth.return_value.authenticate.return_value = (mock_user, "access")

    mock_refresh_class.side_effect = Exception("bad token")

    view = LogoutView.as_view()
    req = rf.post("/logout", {"refresh_token": "bad"}, format="json")
    resp = view(req)

    assert resp.status_code == status.HTTP_401_UNAUTHORIZED
    assert resp.data["error"] == "Invalid token"


def _call_change_patch(rf, user, data):
    from user_management.views import ChangeUserDataView
    view = ChangeUserDataView.as_view()
    req = rf.patch("/user", data, format="json")
    force_authenticate(req, user=user)
    return view(req)

def test_change_user_data_updates_names_and_saves(rf):
    user = _mock_user(first_name="Old", last_name="Old")
    resp = _call_change_patch(rf, user, {"first_name": "New", "last_name": "Name"})
    assert resp.status_code == 200
    user.save.assert_called_once()
    assert user.first_name == "New"
    assert user.last_name == "Name"

def test_change_user_data_password_requires_current(rf):
    user = _mock_user()
    resp = _call_change_patch(rf, user, {"new_password": "new-secret"})
    assert resp.status_code == 400
    assert resp.data["error"] == "Podaj aktualne hasło."

def test_change_user_data_wrong_current_password(rf):
    user = _mock_user()
    user.check_password.return_value = False
    resp = _call_change_patch(rf, user, {"new_password": "new", "password": "bad"})
    assert resp.status_code == 401
    assert resp.data["error"] == "Aktualne hasło jest nieprawidłowe."

def test_change_user_data_password_success(rf):
    user = _mock_user()
    user.check_password.return_value = True
    resp = _call_change_patch(rf, user, {"new_password": "new", "password": "old"})
    assert resp.status_code == 200
    user.set_password.assert_called_once_with("new")
    user.save.assert_called_once()

@pytest.mark.django_db
def test_register_serializer_creates_user(monkeypatch):
    from user_management.serializers import RegisterSerializer
    from types import SimpleNamespace

    def fake_create(self, validated_data):
        return SimpleNamespace(**validated_data)

    monkeypatch.setattr(RegisterSerializer, "create", fake_create, raising=True)

    ser = RegisterSerializer(data={"email": "a@a.com", "username": "u", "password": "secret123"})
    assert ser.is_valid(), ser.errors
    user = ser.save()
    assert user.email == "a@a.com"
    assert user.username == "u"


def test_login_serializer_verify_calls_authenticate():
    from user_management.serializers import LoginSerializer

    fake_user = MagicMock()
    with patch("user_management.serializers.authenticate") as fake_auth:
        fake_auth.return_value = fake_user

        email, password = "e@e.com", "secret123"
        ser = LoginSerializer(data={"email": email, "password": password})
        assert ser.is_valid(), ser.errors

        data = ser.verify({"email": email, "password": password})
        assert data["user"] is fake_user
        fake_auth.assert_called_once_with(email=email, password=password)

@pytest.mark.django_db
def test_custom_user_manager_requires_data():
    from user_management.models import CustomUser

    with pytest.raises(ValueError):
        CustomUser.objects.create_user(email=None, username=None, password=None)
