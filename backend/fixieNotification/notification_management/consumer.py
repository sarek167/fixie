import json
from channels.generic.websocket import AsyncWebsocketConsumer
from utils.decorators import jwt_required_ws
from .models import Notification
from asgiref.sync import SyncToAsync
from datetime import datetime

# from django.utils.decorators import method_decorator

class NotificationConsumer(AsyncWebsocketConsumer):
    @jwt_required_ws
    async def connect(self):
        print(f"WebSocket connected for user {self.user_id}")
        self.group_name = f"user_{self.user_id}"
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()

        get_pending = SyncToAsync(
            lambda: list(Notification.objects.filter(user_id=self.user_id, delivered=False, ))
        )

        update_delivered = SyncToAsync(
           lambda notification_ids: Notification.objects.filter(id__in=notification_ids).update(delivered=True, delivered_at=datetime.now())
        )

        pending = await get_pending()

        if pending:
            notification_ids = []
            for notification in pending:
                await self.send(text_data=json.dumps(notification.payload))
                notification_ids.append(notification.id)
            await update_delivered(notification_ids)        

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive(self, text_data):
        print(f"OTRZYMANO: {text_data}")

    async def send_notification(self, event):
        print("W SEND_NOTIFICATION")
        await self.send(text_data=json.dumps({
            "title": event.get("title"),
            "message": event.get("message"),
            "container_name": event.get("container_name"),
            "blob_name": event.get("blob_name"),
        }))