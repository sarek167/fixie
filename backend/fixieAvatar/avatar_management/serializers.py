from rest_framework import serializers
from .models import Reward, AvatarState

class RewardSerializer(serializers.ModelSerializer):
    color_to_display = serializers.SerializerMethodField()

    class Meta:
        model = Reward
        fields = [
            'id',
            'blob_name',
            'container_name',
            'starter',
            'trigger_type',
            'trigger_value',
            'color_to_display'
        ]
    
    def get_color_to_display(self, obj):
        if hasattr(obj, 'color_to_display'):
            return obj.color_to_display
        return obj.color.hex if obj.color else None

class AvatarStateSerializer(serializers.ModelSerializer):
    class Meta:
        model = AvatarState
        fields = [
            'id',
            'skin_color',
            'eyes_color',
            'hair',
            'hair_color',
            'top_clothes',
            'top_clothes_color',
            'bottom_clothes',
            'bottom_clothes_color',
            'lipstick',
            'blush'
        ]
