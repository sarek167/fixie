from rest_framework import serializers
from .models import Reward

class RewardSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reward
        fields = [
            'id',
            'name',
            'description',
            'blob_name',
            'container_name',
            'starter',
            'trigger_type',
            'trigger_value',
            'color_to_display'
        ]
