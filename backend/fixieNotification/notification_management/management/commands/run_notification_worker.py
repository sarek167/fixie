import json
from kafka import KafkaConsumer
from django.core.management.base import BaseCommand
from django.conf import settings
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from notification_management.models import Notification
from datetime import datetime


class Command(BaseCommand):
    help = 'Runs Kafka consumer to listen for notifications to show'

    def handle(self, *args, **options):
        consumer = KafkaConsumer(
            'reward-granted',
            bootstrap_servers=f'{settings.KAFKA_IP}:{settings.KAFKA_PORT}',
            group_id='notification-consumer-group',
            value_deserializer=lambda m: json.loads(m.decode('utf-8')),
            auto_offset_reset='earliest',
            enable_auto_commit=True
        )

        self.stdout.write(self.style.SUCCESS('Notification worker started. Listening for notifications to show...'))

        for message in consumer:
            topic = message.topic
            data = message.value
            user_id = data.pop('user_id', None)

            if not user_id:
                self.stdout.stderr.write('Missing user_id in message. Skipping...')
                continue
            self.stdout.write(f"TOPIC: {topic}")
            self.stdout.write(f"MESSAGE: {message}")
            self.stdout.write(f"USER ID {user_id}")
            self.stdout.write(f"DATA: {data}")
            channel_layer = get_channel_layer()

            try:
                if channel_layer is None or not async_to_sync(channel_layer.group_send):
                    raise RuntimeError("No active channels to send notification")


                async_to_sync(channel_layer.group_send)(
                    f"user_{user_id}",
                    {
                        "type": "send_notification",
                        "title": data.get("title"),
                        "container_name": data.get("container_name"),
                        "blob_name": data.get("blob_name"),
                        "message": data.get("message")
                    }
                )
                Notification.objects.create(user_id=user_id, payload=data, delivered = True, delivered_at = datetime.now())

            except Exception as e:
                self.stderr.write(f"User is offline or error processing topic's {topic} message: {e}. Saving notification to DB.")
                Notification.objects.create(user_id=user_id, payload=data, delivered = False)
    
