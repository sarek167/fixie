from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class Reward(models.Model):
    TRIGGER_TYPE_CHOICES = [
        ('task_completion', 'Task Completion'),
        ('streak', 'Streak'),
        ('path_completion', 'Path Completion'),
    ]

    name = models.CharField(max_length=255)
    description = models.TextField()
    blob_name = models.CharField(max_length=255)
    container_name = models.CharField(max_length=255)
    starter = models.BooleanField()
    trigger_type = models.CharField(
        max_length=20,
        choices=TRIGGER_TYPE_CHOICES,
        null=True,
        blank=True
    )
    trigger_value = models.IntegerField(null=True, blank=True)
    color_to_display = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return self.name

    class Meta:
        db_table = "rewards"


class UserReward(models.Model):
    reward = models.ForeignKey(Reward, on_delete=models.CASCADE)
    user_id = models.IntegerField()
    date_awarded = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user} - {self.reward.name}"

    class Meta:
        db_table = "user_rewards"

