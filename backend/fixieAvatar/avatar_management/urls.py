from django.urls import path
from .views import UserAvatarElementsView

urlpatterns = [
    path("get_user_avatar_elem/", UserAvatarElementsView.as_view(), name="register"),
    # path("login/", LoginView.login, name="login"),
    # path("logout/", LoginView.logout, name="logout"),
    # path('token_refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]