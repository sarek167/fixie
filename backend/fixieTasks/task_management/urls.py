from django.urls import path
from .views import UserPathsView, PopularPathsView, PathByTitleView, UserTaskAnswerView, UserPathView, StreakView, DailyTasksView, DailyTasksStatusView

urlpatterns = [
    path("get_user_paths/", UserPathsView.as_view(), name="get_user_paths"),
    path("get_popular_paths/", PopularPathsView.as_view(), name="get_popular_paths"),
    path("get_path_by_title/", PathByTitleView.as_view(), name="get_path_by_title"),
    path("post_task_answer/", UserTaskAnswerView.as_view(), name="post_task_answer"),
    path("post_assign_path/", UserPathView.as_view(), name="post_assign_path"),
    path("get_streak/", StreakView.as_view(), name="get_streak"),
    path("get_daily_tasks/", DailyTasksView.as_view(), name="get_daily_tasks"),
    path("post_daily_tasks/", DailyTasksView.as_view(), name="post_daily_tasks"),
    path("get_daily_tasks_status/", DailyTasksStatusView.as_view(), name="get_daily_tasks_status")
]