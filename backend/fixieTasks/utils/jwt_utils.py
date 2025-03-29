import jwt
from django.conf import settings

with open(settings.PUBLIC_KEY_PATH, "r") as f:
    PUBLIC_KEY = f.read()

def decode_jwt(token: str):
    try:
        payload = jwt.decode(token, PUBLIC_KEY, algorithms=["RS256"])
        print(payload)
        return payload
    except jwt.ExpiredSignatureError:
        raise ValueError("Token expired")
    except jwt.InvalidTokenError:
        raise ValueError("Incorrect token")