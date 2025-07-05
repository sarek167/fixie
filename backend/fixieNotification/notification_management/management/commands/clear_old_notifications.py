from django.core.management.base import BaseCommand
from notification_management.models import Notification
from django.utils import timezone
from datetime import timedelta

class Command(BaseCommand):
    help = 'Removes old notifications from database'

    def handle(self, *args, **kwargs):
        now = timezone.now()

        read_cutoff_date = now - timedelta(days=7)
        read_deleted, _ = Notification.objects.filter(
            delivered = True,
            delivered_at__lt=read_cutoff_date
        ).delete()

        unread_cutoff_date = now-timedelta(days=180)
        unread_deleted, _ = Notification.objects.filter(
            delivered=False,
            created_at__lt=unread_cutoff_date
        ).delete()

        self.stdout.write(self.style.SUCCESS(
            f"Deleted {read_deleted} read and {unread_deleted} unread notifications."
        ))