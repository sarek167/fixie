from functools import wraps
from django.http import JsonResponse
from utils.jwt_utils import decode_jwt

def jwt_required(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        auth_header = request.META.get("HTTP_AUTHORIZATION")
        
        if not auth_header or not auth_header.startswith("Bearer"):
            return JsonResponse({"error": "Token not found"}, status=401)
        token = auth_header.split(" ")[1]
        try:
            payload = decode_jwt(token)
            request.user_id = payload.get("user_id") or payload.get("sub")
        except ValueError as e:
            return JsonResponse({"error": str(e)}, status=401)
        return view_func(request, *args, **kwargs)
    return wrapper