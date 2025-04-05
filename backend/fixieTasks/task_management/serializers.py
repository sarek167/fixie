from rest_framework import serializers
from .models import Path, Task, UserTaskAnswer

class PathSerializer(serializers.ModelSerializer):
    class Meta:
        model = Path
        fields = [
            'title',
            'description',
            'image_url',
            'color_hex',
        ]


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
            'date_for_daily',
            'answer_type',
            'created_at',
            'updated_at'
        ]
    def validate(self, data):
        task = data.get('task') or self.instance.task
        answer_type = task.answer_type

        if answer_type == 'text' and not data.get('text_answer'):
            raise serializers.ValidationError("This task requires a text answer.")
        if answer_type == 'checkbox' and data.get('checkbox_answer') is None:
            raise serializers.ValidationError("This task requires a checkbox answer.")

        return data

class UserTaskAnswerSerializer(serializers.ModelSerializer):
    task = TaskSerializer(read_only=True)
    task_id = serializers.PrimaryKeyRelatedField(queryset=Task.objects.all(), write_only=True)
    class Meta:
        model = UserTaskAnswer
        fields = [
            'id',
            'user_id',
            'task_id',
            'text_answer',
            'checkbox_answer',
            'status',
            'answered_at'
        ]