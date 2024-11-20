from rest_framework import serializers
from .models import CustomUser
from django.contrib.auth import authenticate

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ('email', 'username', 'password', 'first_name', 'last_name')

    def create(self, verified_data):
        user = CustomUser.objects.create_user(
            email = verified_data["email"],
            username = verified_data["username"],
            password = verified_data["password"],
            first_name = verified_data["first_name"],
            last_name = verified_data["last_name"]
        )
        return user
    
class LoginSerializer(serializers.ModelSerializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ('email', 'password')

    def verify(self, data):
        user = authenticate(email=data['email'], password=data['password'])
        if user and user.is_active:
            data['user'] = user
            return data
        raise serializers.ValidationError("Incorrect password or email")