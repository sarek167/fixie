from django.shortcuts import render
from .models import Reward, UserReward
from .serializers import RewardSerializer
from utils.jwt_utils import decode_jwt
from utils.decorators import jwt_required
from rest_framework.views import APIView
from collections import defaultdict
from django.http import JsonResponse
from django.utils.decorators import method_decorator

@method_decorator(jwt_required, name='dispatch')
class UserAvatarElementsView(APIView):
    def get(self, request):
        elements = Reward.objects.filter(starter=True)
        
        reward_elements_assignments = UserReward.objects.filter(user_id=request.user_id)
        reward_elements = Reward.objects.filter(id__in=[assignment.reward_id for assignment in reward_elements_assignments])
        
        elements = elements | reward_elements

        grouped = defaultdict(list)
        for elem in elements:
            serialized = RewardSerializer(elem).data
            grouped[elem.container_name].append(serialized)

        return JsonResponse(grouped)