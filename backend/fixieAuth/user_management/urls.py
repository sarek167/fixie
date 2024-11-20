from django.urls import path
from .views import RegisterView, LoginView

urlpatterns = [
    path("register/", RegisterView.register, name="register"),
    path("login/", LoginView.login, name="login"),
    path("logout/", LoginView.logout, name="logout")
]