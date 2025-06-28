import json
from channels.generic.websocket import AsyncWebsocketConsumer
from utils.decorators import jwt_required_ws
# from django.utils.decorators import method_decorator

class NotificationConsumer(AsyncWebsocketConsumer):
    @jwt_required_ws
    async def connect(self):
        print(f"WebSocket connected for user {self.user_id}")
        self.group_name = f"user_{self.user_id}"
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()
        

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive(self, text_data):
        print(f"OTRZYMANO: {text_data}")

    async def send_notification(self, event):
        await self.send(text_data=json.dumps(event["message"]))