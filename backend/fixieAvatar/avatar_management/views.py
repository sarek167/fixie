from django.shortcuts import render
from .models import Reward, UserReward, AvatarState
from .serializers import RewardSerializer, AvatarStateSerializer
from utils.jwt_utils import decode_jwt
from utils.decorators import jwt_required
from rest_framework.views import APIView
from collections import defaultdict
from django.http import JsonResponse
from django.utils.decorators import method_decorator
from django.db.models import F
from kafka import KafkaProducer
import json
from django.conf import settings

producer = KafkaProducer(
    bootstrap_servers=f'{settings.KAFKA_IP}:{settings.KAFKA_PORT}',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

@method_decorator(jwt_required, name='dispatch')
class UserAvatarElementsView(APIView):
    def get(self, request):
        elements = Reward.objects.filter(starter=True).select_related('color').annotate(
            color_to_display = F('color__hex')
        )
        reward_elements_assignments = UserReward.objects.filter(user_id=request.user_id)
        reward_elements = Reward.objects.filter(id__in=[assignment.reward_id for assignment in reward_elements_assignments]).select_related('color').annotate(
            color_to_display = F('color__hex')
        )
        
        elements = elements | reward_elements

        grouped = defaultdict(list)
        for elem in elements:
            serialized = RewardSerializer(elem).data
            grouped[elem.container_name].append(serialized)
        # print(grouped)
        return JsonResponse(grouped)

@method_decorator(jwt_required, name='dispatch')
class AvatarStateView(APIView):
    def get(self, request):
        try:
            avatar = AvatarState.objects.get(user_id=request.user_id)
            serializer = AvatarStateSerializer(avatar)
            return JsonResponse(serializer.data)
        except AvatarState.DoesNotExist:
            return JsonResponse({"status": "Avatar state not found."}, status=204)
    
    def put(self, request):
        avatar_data = request.data.copy()
        avatar_data['user_id'] = request.user_id

        producer.send('avatar-updates', avatar_data)
        return JsonResponse({"status": "update enqueued"}, status=202)