from django.shortcuts import render
from .models import Reward
from utils.jwt_utils import decode_jwt
from utils.decorators import jwt_required
from rest_framework.views import APIView
from django.http import JsonResponse

# Create your views here.
# @method_decorator(jwt_required, name='dispatch')
class UserAvatarElementsView(APIView):
    def get(self, request):
        starter_elements = Reward.objects.filter(starter=True)
        print(starter_elements)
        # user_paths = [Path.objects.get(id=assignment.path_id) for assignment in user_paths_assignments]
        # paths_data = [{
        #     "title": user_path.title,
        #     "background_type": (
        #         "image" if user_path.image_url else
        #         "color" if user_path.color_hex else
        #         "default"
        #     ),
        #     "background_value": (
        #         user_path.image_url or
        #         user_path.color_hex or
        #         "#FFFFFF"
        #     )
        # } for user_path in user_paths]
        return JsonResponse({"user_paths": starter_elements})