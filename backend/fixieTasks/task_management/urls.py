from django.urls import path
from .views import UserPathsView, PopularPathsView

urlpatterns = [
    path("get_user_paths/", UserPathsView.as_view(), name="get_user_paths"),
    path("get_popular_paths/", PopularPathsView.as_view(), name="get_popular_paths"),
]