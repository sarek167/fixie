from django.urls import path
from .views import RegisterView, LoginView
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path("register/", RegisterView.register, name="register"),
    path("login/", LoginView.login, name="login"),
    path("logout/", LoginView.logout, name="logout"),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]