from django.db import models

class Notification(models.Model):
    user_id = models.IntegerField()
    payload = models.JSONField()
    delivered = models.BooleanField(default=False)
    delivered_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "notifications"