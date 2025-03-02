from rest_framework import generics, status
from rest_framework.response import Response
from .serializers import RegisterSerializer, LoginSerializer
from django.contrib.auth import login
from django.conf import settings
import uuid
import redis
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view
from django.core.cache import cache


redis_inst = redis.StrictRedis(host=settings.REDIS_HOST, port=settings.REDIS_PORT)

class RegisterView(APIView):
    @api_view(['POST'])
    def register(request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            session_id = str(uuid.uuid4())
            redis_inst.set(user.id, session_id, settings.SESSION_COOKIE_AGE)
            response = Response({"message": "User registered successfuly", "user_id": user.id}, status=status.HTTP_201_CREATED)
            response.set_cookie(
                key='session_id',
                value=session_id,
                httponly=settings.SESSION_COOKIE_HTTPONLY,
                secure=settings.SESSION_COOKIE_SECURE,
                samesite='Lax'
            )
            return response
        print(serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        

class LoginView(APIView):
    @api_view(['POST'])
    def login(request):
        serializer = LoginSerializer(data = request.data)
        # request.data._mutable = True
        print("W logowaniu")
        verified_data = serializer.verify(request.data)
        user = verified_data['user']
        print("PO WERYFIKACJI")
        session_id = str(uuid.uuid4())
        redis_inst.set(user.id, session_id, settings.SESSION_COOKIE_AGE)
        print(redis_inst.get(user.id))
        response = Response({"message": "Login succesful"}, status=status.HTTP_200_OK)
        response.set_cookie(
            key='session_id',
            value=session_id,
            httponly=settings.SESSION_COOKIE_HTTPONLY,
            secure=settings.SESSION_COOKIE_SECURE,
            samesite='Lax'
        )
        return response
    
    @api_view(['POST'])
    def logout(request):
        session_id = request.COOKIES.get('session_id')
        if session_id:
            redis_inst.delete(session_id)
        response = Response({"message": "Logout successful"}, status=status.HTTP_200_OK)
        response.delete_cookie('session_id')
        return response