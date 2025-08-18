import json
from kafka import KafkaConsumer, KafkaProducer, errors as kerrors
from django.core.management.base import BaseCommand
from avatar_management.models import AvatarState, UserReward, Reward
from django.conf import settings
from avatar_management.serializers import RewardSerializer
import os
import logging

log = logging.getLogger(__name__)

def _kafka_cfg():
    return {
        "bootstrap_servers": os.getenv("KAFKA_BOOTSTRAP_SERVERS"),
        "security_protocol": os.getenv("KAFKA_SECURITY_PROTOCOL", "PLAINTEXT"),
        "sasl_mechanism": os.getenv("KAFKA_SASL_MECHANISM"),
        "sasl_plain_username": os.getenv("KAFKA_SASL_USERNAME"),
        "sasl_plain_password": os.getenv("KAFKA_SASL_PASSWORD"),
    }

class Command(BaseCommand):
    help = 'Runs Kafka consumer to update avatar in database'

    def _mk_producer(self, cfg, retries=10, delay=3):
        for i in range(retries):
            try:
                log.info("KafkaProducer connect: bootstrap=%s proto=%s mech=%s",
                         cfg["bootstrap_servers"], cfg["security_protocol"], cfg["sasl_mechanism"])
                return KafkaProducer(
                    **{k: v for k, v in cfg.items() if v},   # tylko niepuste
                    value_serializer=lambda v: json.dumps(v).encode('utf-8'),
                    api_version_auto_timeout_ms=10000,
                )
            except kerrors.NoBrokersAvailable as e:
                log.warning("KafkaProducer attempt %d/%d: %s", i+1, retries, e)
                time.sleep(delay)
        raise kerrors.NoBrokersAvailable()

    def _mk_consumer(self, cfg, topics):
        return KafkaConsumer(
            *topics,
            **{k: v for k, v in cfg.items() if v},
            group_id='avatar-consumer-group',
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

        producer = self._mk_producer(cfg)
        consumer = self._mk_consumer(cfg, [
            'avatar-updates', 'path-completed-event',
            'task-completed-event', 'streak-completed-event'
        ])

        self.stdout.write(self.style.SUCCESS(
            f"Avatar worker started. bootstrap={cfg['bootstrap_servers']}"))

        try:
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

        except Exception as e:
            self.stderr.write(f"Fatal error: {e}")
        finally:
            try: consumer.close()
            except: pass
            try: producer.flush(); producer.close()
            except: pass
    
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
                            "title": "Gratulacje!",
                            "message": "W ramach nagrody otrzymujesz element wyglądu avatara!",
                            "container_name": serialized_reward["container_name"],
                            "blob_name": serialized_reward["blob_name"]
                        }
                    )

                    self.stdout.write(f"User with ID {user_id} received reward with id {reward.id}")
        except Reward.DoesNotExist:
            # there is no reward for this path
            return
