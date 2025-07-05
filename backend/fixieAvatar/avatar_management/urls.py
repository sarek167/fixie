from django.urls import path
from .views import UserAvatarElementsView, AvatarStateView

urlpatterns = [
    path("get_user_avatar_elem/", UserAvatarElementsView.as_view(), name="get_elems"),
    path("get_avatar_state/", AvatarStateView.as_view(), name="get_avatar_state"),
    path("put_avatar_state/", AvatarStateView.as_view(), name="put_avatar_state")
]