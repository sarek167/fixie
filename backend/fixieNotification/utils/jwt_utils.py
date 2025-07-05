import jwt
from django.conf import settings

_public_key_cache = None

def get_public_key():
    global _public_key_cache
    if _public_key_cache is None:
        with open(settings.PUBLIC_KEY_PATH, "r") as f:
            _public_key_cache = f.read()
    return _public_key_cache

def decode_jwt(token: str):
    try:
        payload = jwt.decode(token, get_public_key(), algorithms=["RS256"])
        return payload
    except jwt.ExpiredSignatureError:
        raise ValueError("Token expired")
    except jwt.InvalidTokenError:
        raise ValueError("Incorrect token")