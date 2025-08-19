import json
from kafka import KafkaConsumer
from django.core.management.base import BaseCommand
from django.conf import settings
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from notification_management.models import Notification
from django.utils import timezone
import os

def _kafka_cfg():
    return {
        "bootstrap_servers": os.getenv("KAFKA_BOOTSTRAP_SERVERS"),
        "security_protocol": os.getenv("KAFKA_SECURITY_PROTOCOL", "PLAINTEXT"),
        "sasl_mechanism": os.getenv("KAFKA_SASL_MECHANISM"),
        "sasl_plain_username": os.getenv("KAFKA_SASL_USERNAME"),
        "sasl_plain_password": os.getenv("KAFKA_SASL_PASSWORD"),
    }


class Command(BaseCommand):
    help = 'Runs Kafka consumer to listen for notifications to show'

    def _mk_consumer(self, cfg, topics):
        return KafkaConsumer(
            *topics,
            **{k: v for k, v in cfg.items() if v},
            group_id='notification-consumer-group',
            value_deserializer=lambda m: json.loads(m.decode('utf-8')),
            auto_offset_reset='earliest',
            enable_auto_commit=True,
            api_version_auto_timeout_ms=10000,
        )

    def handle(self, *args, **options):
        cfg = _kafka_cfg() 
        if not cfg["bootstrap_servers"]:
            self.stderr.write("KAFKA_BOOTSTRAP_SERVERS is empty")
            return
        
        consumer = self._mk_consumer(cfg, ['reward-granted'])

        self.stdout.write(self.style.SUCCESS('Notification worker started. Listening for notifications to show...'))

        for message in consumer:
            topic = message.topic
            data = message.value
            user_id = data.pop('user_id', None)

            if not user_id:
                self.stderr.write('Missing user_id in message. Skipping...')
                continue
            self.stdout.write(f"TOPIC: {topic}")
            self.stdout.write(f"MESSAGE: {message}")
            self.stdout.write(f"USER ID {user_id}")
            self.stdout.write(f"DATA: {data}")
            channel_layer = get_channel_layer()

            try:
                if channel_layer is None or not hasattr(channel_layer, "group_send"):
                    raise RuntimeError("No active channels to send notification")

                notification = Notification.objects.create(
                    user_id=user_id,
                    payload=data,
                    delivered=False
                )

                async_to_sync(channel_layer.group_send)(
                    f"user_{user_id}",
                    {
                        "type": "send_notification",
                        "title": data.get("title"),
                        "container_name": data.get("container_name"),
                        "blob_name": data.get("blob_name"),
                        "message": data.get("message"),
                        "notification_id": notification.id
                    }
                )

            except Exception as e:
                self.stderr.write(f"User is offline or error processing topic's {topic} message: {e}. Saving notification to DB.")
    
