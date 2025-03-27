from django.urls import path
from .views import UserPathsView

urlpatterns = [
    path("get/", UserPathsView.get, name="get"),
]