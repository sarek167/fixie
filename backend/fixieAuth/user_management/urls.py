from django.urls import path
from .views import RegisterView, LoginView, ChangeUserDataView, LogoutView
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path("register/", RegisterView.register, name="register"),
    path("login/", LoginView.login, name="login"),
    path("logout/", LogoutView.as_view(), name="logout"),
    path('token_refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path("change_user_data/", ChangeUserDataView.as_view(), name="change_user_data")
]