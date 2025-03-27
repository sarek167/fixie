from django.http import JsonResponse
from .models import UserPath, Path
from utils.jwt_utils import decode_jwt
from utils.decorators import jwt_required
from rest_framework.views import APIView
from rest_framework.decorators import api_view

class UserPathsView(APIView):
    @jwt_required
    def get(request):
        user_paths_assignments = UserPath.objects.filter(user_id=request.user_id)
        user_paths = [Path.objects.filter(id=user_paths_assignment.path_id)[0] for user_paths_assignment in user_paths_assignments]
        print(f"PATHS: {user_paths[0]}")
        paths_data = [{
            "title": user_path.title,
            "description": user_path.description
        } for user_path in user_paths]
        print(paths_data)
        return JsonResponse({"user_path": paths_data})