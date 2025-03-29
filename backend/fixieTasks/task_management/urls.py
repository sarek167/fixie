from django.urls import path
from .views import UserPathsView

urlpatterns = [
    path("get_user_paths/", UserPathsView.as_view(), name="get_user_paths"),
]