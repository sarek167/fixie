from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class Colors(models.Model):
    name = models.CharField(max_length=20)
    hex = models.CharField(max_length=20)

    class Meta:
        db_table = "colors"

class Reward(models.Model):
    TRIGGER_TYPE_CHOICES = [
        ('task_completion', 'Task Completion'),
        ('streak', 'Streak'),
        ('path_completion', 'Path Completion'),
    ]

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
    color = models.ForeignKey(Colors, on_delete=models.SET_NULL, null=True, related_name='rewards')

    class Meta:
        db_table = "rewards"


class UserReward(models.Model):
    reward = models.ForeignKey(Reward, on_delete=models.CASCADE)
    user_id = models.IntegerField()
    date_awarded = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user} - {self.reward.blob_name}"

    class Meta:
        db_table = "user_rewards"

class AvatarState(models.Model):
    user_id = models.IntegerField()
    skin_color = models.CharField(max_length=20)
    eyes_color = models.CharField(max_length=20)
    hair = models.CharField(max_length=50)
    hair_color = models.CharField(max_length=20)
    top_clothes = models.CharField(max_length=50)
    top_clothes_color = models.CharField(max_length=20)
    bottom_clothes = models.CharField(max_length=50)
    bottom_clothes_color = models.CharField(max_length=20)
    beard = models.CharField(max_length=50)
    lipstick = models.CharField(max_length=10, default="0")
    blush = models.CharField(max_length=10, default="0")

    class Meta:
        db_table = "avatar_state"

