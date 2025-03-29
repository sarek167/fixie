from django.http import JsonResponse
from .models import UserPath, Path
from utils.jwt_utils import decode_jwt
from utils.decorators import jwt_required
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from django.utils.decorators import method_decorator

@method_decorator(jwt_required, name='dispatch')
class UserPathsView(APIView):
    def get(self, request):
        user_paths_assignments = UserPath.objects.filter(user_id=request.user_id)
        user_paths = [Path.objects.get(id=assignment.path_id) for assignment in user_paths_assignments]
        print(f"PATHS: {user_paths[0]}")
        paths_data = [{
            "title": user_path.title,
            "background_type": (
                "image" if user_path.image_url else
                "color" if user_path.color_hex else
                "default"
            ),
            "background_value": (
                user_path.image_url or
                user_path.color_hex or
                "#FFFFFF"
            )
        } for user_path in user_paths]
        print(paths_data)
        return JsonResponse({"user_path": paths_data})