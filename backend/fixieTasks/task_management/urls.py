from django.urls import path
from .views import UserPathsView, PopularPathsView, PathByTitleView, UserTaskAnswerView

urlpatterns = [
    path("get_user_paths/", UserPathsView.as_view(), name="get_user_paths"),
    path("get_popular_paths/", PopularPathsView.as_view(), name="get_popular_paths"),
    path("get_path_by_title/", PathByTitleView.as_view(), name="get_path_by_title"),
    path("post_task_answer/", UserTaskAnswerView.as_view(), name="post_task_answer"),
]