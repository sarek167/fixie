from rest_framework import generics, status
from rest_framework.response import Response
from .serializers import RegisterSerializer, LoginSerializer
from django.contrib.auth import login
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication

class RegisterView(APIView):
    @api_view(['POST'])
    def register(request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            print(user)
            response = Response({
                "message": "User registered successfuly", 
                "id": user.id,
                "access_token": access_token,
                "refresh_token": str(refresh),
                "email": user.email,
                "username": user.username,
                "first_name": user.first_name,
                "last_name": user.last_name,
            }, status=status.HTTP_201_CREATED)

            return response
        print(serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        

class LoginView(APIView):
    @api_view(['POST'])
    def login(request):
        try:
            serializer = LoginSerializer(data = request.data)
            if serializer.is_valid():
                data = serializer.verify(request.data)
                user = data["user"]
                refresh = RefreshToken.for_user(user)
                access_token = str(refresh.access_token)
                print(user)
                print(user.id)
                return Response({
                    "message": "Login succesful",
                    "access_token": access_token,
                    "refresh_token": str(refresh),
                    "id": user.id,
                    "email": user.email,
                    "username": user.username,
                    "first_name": user.first_name,
                    "last_name": user.last_name,
                }, status=status.HTTP_200_OK)
            return Response({"error": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            print(e)
    
    @api_view(['POST'])
    @authentication_classes([JWTAuthentication])
    @permission_classes([IsAuthenticated])
    def logout(request):
        try:
            refresh_token = request.data['refresh_token']
            if not refresh_token:
                return Response({"error": "Refresh token missing"}, status=status.HTTP_400_BAD_REQUEST)
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({"message": "Logout successful"}, status=status.HTTP_200_OK)
        except Exception as e:
            print(e)
            return Response({"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)