import json
from channels.generic.websocket import AsyncWebsocketConsumer
from utils.decorators import jwt_required_ws
from .models import Notification
from asgiref.sync import SyncToAsync, sync_to_async
from django.utils import timezone


# from django.utils.decorators import method_decorator

@sync_to_async
def _get_pending(user_id: int):
    return list(
        Notification.objects
        .filter(user_id=user_id, delivered=False)
        .order_by("created_at")
        .only("id", "payload")
    )

@sync_to_async
def _mark_delivered(notification_id: int, user_id: int) -> int:
    return (Notification.objects
            .filter(id=notification_id, user_id=user_id, delivered=False)
            .update(delivered=True, delivered_at=timezone.now()))
class NotificationConsumer(AsyncWebsocketConsumer):
    @jwt_required_ws
    async def connect(self):
        print(f"WebSocket connected for user {self.user_id}")
        self.group_name = f"user_{self.user_id}"
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()

        pending = await _get_pending(self.user_id)

        for notification in pending:
            payload = dict(notification.payload)
            payload.update({
                "notification_id": notification.id,
                "title": payload.get("title"),
                "message": payload.get("message"),
                "container_name": payload.get("container_name"),
                "blob_name": payload.get("blob_name"),
            })
            await self.send(text_data=json.dumps(payload))    

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive(self, text_data):
        print(f"OTRZYMANO: {text_data}")
        try:
            data = json.loads(text_data)
        except Exception as e:
            print(f"Error parsing JSON: {e}")
            return

        if data.get("type") == "ack":
            notification_id = data.get("notification_id")
            if notification_id is not None:
                await _mark_delivered(notification_id, self.user_id)
                print(f"Notification {notification_id} marked as delivered.")
            return
    
    async def send_notification(self, event):
        await self.send(text_data=json.dumps({
            "title": event.get("title"),
            "message": event.get("message"),
            "container_name": event.get("container_name"),
            "blob_name": event.get("blob_name"),
            "notification_id": event.get("notification_id")
        }))