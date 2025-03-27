from django.http import JsonResponse
from .models import UserPath, Path
from utils.jwt_utils import decode_jwt
from rest_framework.views import APIView
from rest_framework.decorators import api_view

class UserPathsView(APIView):
    def get(request):
        auth_header = request.headers.get("Authorization")

        if not auth_header or not auth_header.startswith("Bearer "):
            return JsonResponse({"error": "No token found"}, status=401)

        token = auth_header.split(" ")[1]

        try:
            payload = decode_jwt(token)
            user_id = payload.get("user_id") or payload.get("sub")
        except ValueError as e:
            return JsonResponse({"error": str(e)}, status=401)

        user_paths_assignments = UserPath.objects.filter(user_id=user_id)
        user_paths = [Path.objects.filter(id=user_paths_assignment.path_id)[0] for user_paths_assignment in user_paths_assignments]
        print(f"PATHS: {user_paths[0]}")
        paths_data = [{
            "title": user_path.title,
            "description": user_path.description
        } for user_path in user_paths]
        print(paths_data)
        return JsonResponse({"user_path": paths_data})