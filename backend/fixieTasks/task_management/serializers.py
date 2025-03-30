from rest_framework import serializers
from .models import Path

class PathSerializer(serializers.ModelSerializer):
    class Meta:
        model = Path
        fields = [
            'title',
            'description',
            'image_url',
            'color_hex',
        ]

from rest_framework import serializers
from .models import Task, UserTask

class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = [
            'id',
            'title',
            'description',
            'category',
            'difficulty',
            'type',
            'created_at',
            'updated_at'
        ]


class UserTaskSerializer(serializers.ModelSerializer):
    task = TaskSerializer(read_only=True)  # Jeśli chcesz zagnieżdżony obiekt zadania
    task_id = serializers.PrimaryKeyRelatedField(
        queryset=Task.objects.all(), source='task', write_only=True
    )

    class Meta:
        model = UserTask
        fields = [
            'id',
            'user_id',
            'task',
            'task_id',
            'status',
            'assigned_at',
            'completed_at',
            'updated_at'
        ]
