from rest_framework import serializers
from .models import Path

class PathSerializer(serializers.ModelSerializer):
    class Meta:
        model = Path
        fields = [
            'title',
            'description',
            'image_url',
            'color_hex',
        ]
