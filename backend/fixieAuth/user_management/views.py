from rest_framework import generics, status
from rest_framework.response import Response
from .serializers import RegisterSerializer, LoginSerializer
from django.contrib.auth import login
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication

class RegisterView(APIView):
    authentication_classes = []
    permission_classes = []

    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        user = serializer.save()
        refresh = RefreshToken.for_user(user)
        return Response(
            {
                "message": "User registered successfully",
                "id": user.id,
                "access_token": str(refresh.access_token),
                "refresh_token": str(refresh),
                "email": user.email,
                "username": user.username,
                "first_name": user.first_name,
                "last_name": user.last_name,
            },
            status=status.HTTP_201_CREATED,
        )
        
class LoginView(APIView):
    authentication_classes = []
    permission_classes = []

    def post(self, request):
        serializer = LoginSerializer(data=request.data, context={"request": request})
        serializer.is_valid(raise_exception=True)

        user = serializer.validated_data["user"]
        refresh = RefreshToken.for_user(user)
        return Response(
            {
                "message": "Login successful",
                "access_token": str(refresh.access_token),
                "refresh_token": str(refresh),
                "id": user.id,
                "email": user.email,
                "username": user.username,
                "first_name": user.first_name,
                "last_name": user.last_name,
            },
            status=status.HTTP_200_OK,
        )

    

class LogoutView(APIView):
    def post(self, request):
        try:
            refresh_token = request.data['refresh_token']
            if not refresh_token:
                return Response({"error": "Refresh token missing"}, status=status.HTTP_401_UNAUTHORIZED)
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({"message": "Logout successful"}, status=status.HTTP_200_OK)
        except Exception as e:
            print(e)
            return Response({"error": "Invalid token"}, status=status.HTTP_401_UNAUTHORIZED)
        
class ChangeUserDataView(APIView):
    @authentication_classes([JWTAuthentication])
    @permission_classes([IsAuthenticated])
    def patch(self, request):
        try:
            user = request.user
            email = request.data.get("email")
            new_password = request.data.get("new_password")
            password = request.data.get("password")
            first_name = request.data.get("first_name")
            last_name = request.data.get("last_name")
            print(f"DATA: {request.data}")
            print(f"USER: {request.user}")
            if new_password:
                if not password:
                    return Response(
                        {"error": "Podaj aktualne hasło."},
                        status=status.HTTP_400_BAD_REQUEST,
                    )
                if not user.check_password(password):
                    return Response(
                        {"error": "Aktualne hasło jest nieprawidłowe."},
                        status=status.HTTP_401_UNAUTHORIZED,
                    )
                user.set_password(new_password)
            if first_name:
                user.first_name = first_name
            if last_name:
                user.last_name = last_name
            user.save()
            return Response({"message": "Dane zaktualizowane."}, status=status.HTTP_200_OK)
            

        except Exception as e:
            print(e)
            return Response({"error": "Error while changing user's data."}, status=status.HTTP_400_BAD_REQUEST)