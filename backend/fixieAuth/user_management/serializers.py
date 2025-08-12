from rest_framework import serializers
from .models import CustomUser
from django.contrib.auth import authenticate

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ('email', 'username', 'password')

    def create(self, verified_data):
        user = CustomUser.objects.create_user(
            email = verified_data["email"],
            username = verified_data["username"],
            password = verified_data["password"],
        )
        return user
    
class LoginSerializer(serializers.ModelSerializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ('email', 'password')

    def validate(self, attrs):
        email = attrs.get("email")
        password = attrs.get("password")
        if not email or not password:
            raise serializers.ValidationError({"detail": "email and password are required"})

        user = authenticate(
            request=self.context.get("request"),
            email=email,
            password=password,
        )

        if not user or not user.is_active:
            raise serializers.ValidationError({"detail": "Incorrect email or password"})

        attrs["user"] = user
        return attrs