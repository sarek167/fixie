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

        return JsonResponse(grouped)

@method_decorator(jwt_required, name='dispatch')
class AvatarStateView(APIView):
    def get(self, request):
        try:
            avatar = AvatarState.objects.get(user_id=request.user_id)
            serializer = AvatarStateSerializer(avatar)
            return JsonResponse(serializer.data)
        except AvatarState.DoesNotExist:
            return JsonResponse({"error": "Avatar state not found."}, status=404)
    
    def put(self, request):
        try:
            avatar = AvatarState.objects.get(user_id=request.user_id)
            serializer = AvatarStateSerializer(avatar, data=request.data, partial=True)
        except AvatarState.DoesNotExist:
            serializer = AvatarStateSerializer(data=request.data)
    
        if serializer.is_valid():
            avatar = serializer.save(user_id=request.user_id)
            return JsonResponse(AvatarStateSerializer(avatar).data, status=200)
        print(serializer)
        return JsonResponse(serializer.errors, status=400) 