import json
from kafka import KafkaConsumer, KafkaProducer
from django.core.management.base import BaseCommand
from avatar_management.models import AvatarState, UserReward, Reward
from django.conf import settings
from avatar_management.serializers import RewardSerializer

producer = KafkaProducer(
    bootstrap_servers=f'{settings.KAFKA_IP}:{settings.KAFKA_PORT}',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

class Command(BaseCommand):
    help = 'Runs Kafka consumer to update avatar in database'

    def handle(self, *args, **options):
        consumer = KafkaConsumer(
            'avatar-updates',
            'path-completed-event',
            'task-completed-event',
            'streak-completed-event',
            bootstrap_servers=f'{settings.KAFKA_IP}:{settings.KAFKA_PORT}',
            group_id='avatar-consumer-group',
            value_deserializer=lambda m: json.loads(m.decode('utf-8')),
            auto_offset_reset='earliest',
            enable_auto_commit=True
        )

        self.stdout.write(self.style.SUCCESS('Avatar worker started. Listening for avatar updates...'))

        for message in consumer:
            topic = message.topic
            data = message.value
            user_id = data.pop('user_id', None)

            if not user_id:
                self.stdout.stderr.write('Missing user_id in message. Skipping...')
                continue

            try:
                self.stdout.write(topic)
                if topic == "avatar-updates":
                    self.avatar_update(data, user_id)
                elif topic == "path-completed-event":
                    self.reward_receive_events(data, user_id, "path_completion")
                elif topic == "task-completed-event":
                    self.reward_receive_events(data, user_id, "task_completion")
                elif topic == "streak-completed-event":
                    self.reward_receive_events(data, user_id, "streak")
            except Exception as e:
                self.stderr.write(f"Error processing topic's {topic} message: {e}")
    
    def avatar_update(self, data, user_id):
        _, created = AvatarState.objects.update_or_create(
            user_id=user_id,
            defaults=data
        )
        status = 'created' if created else 'updated'
        self.stdout.write(f'Avatar {status} for user_id {user_id}')
    
    def reward_receive_events(self, data, user_id, trigger_type):
        self.stdout.write(f"PAYLOAD {data}")
        trigger_value = data.get('trigger_value')
        if not trigger_value:
            raise Exception(f"No trigger value in event. Payload: {data}")
        try:
            reward = Reward.objects.get(trigger_type=trigger_type, trigger_value=trigger_value)
            if reward:
                _, created = UserReward.objects.update_or_create(
                    user_id = user_id,
                    reward = reward
                )
                print(f"CREATED: {created}")
                if created:
                    serialized_reward = RewardSerializer(reward).data
                    producer.send(
                        'reward-granted', 
                        {
                            "user_id": user_id, 
                            "reward": serialized_reward
                        }
                    )

                    self.stdout.write(f"User with ID {user_id} received reward with id {reward.id}")
        except Reward.DoesNotExist:
            # there is no reward for this path
            return
