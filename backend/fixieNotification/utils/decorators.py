from functools import wraps
from django.http import JsonResponse
from utils.jwt_utils import decode_jwt
from urllib.parse import parse_qs

def jwt_required_ws(view_func):
    @wraps(view_func)
    async def wrapper(self, *args, **kwargs):
        try:
            query_string = self.scope["query_string"].decode()
            params = parse_qs(query_string)
            token_list = params.get("token")
            if not token_list:
                await self.close(code=4001)
                return
            token = token_list[0]
            payload = decode_jwt(token)
            self.user_id = payload.get("user_id") or payload.get("sub")
            print(f"W DEKORATORZE USER ID: {self.user_id}")
        except ValueError as e:
            print(f"WebSocket authorization error: {e}")
            await self.close(code=4002)
            return
        return await view_func(self, *args, **kwargs)
    return wrapper
