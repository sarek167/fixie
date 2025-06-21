import json
from kafka import KafkaConsumer
from django.core.management.base import BaseCommand
from avatar_management.models import AvatarState
from django.conf import settings

class Command(BaseCommand):
    help = 'Runs Kafka consumer to update avatar in database'

    def handle(self, *args, **options):
        consumer = KafkaConsumer(
            'avatar-updates',
            bootstrap_servers=f'{settings.KAFKA_IP}:{settings.KAFKA_PORT}',
            group_id='avatar-consumer-group',
            value_deserializer=lambda m: json.loads(m.decode('utf-8')),
            auto_offset_reset='earliest',
            enable_auto_commit=True
        )

        self.stdout.write(self.style.SUCCESS('Avatar worker started. Listening for avatar updates...'))

        for message in consumer:
            data = message.value
            user_id = data.pop('user_id', None)

            if not user_id:
                self.stdout.stderr.write('Missing user_id in message. Skipping...')
                continue

            try:
                avatar, created = AvatarState.objects.update_or_create(
                    user_id=user_id,
                    defaults=data
                )
                status = 'created' if created else 'updated'
                self.stdout.write(f'Avatar {status} for user_id {user_id}')
            except Exception as e:
                self.stderr.write(f"Error processing message: {e}")