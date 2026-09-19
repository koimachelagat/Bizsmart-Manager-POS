# users/serializers.py

from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import User

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        data['name'] = self.user.name
        data['role'] = self.user.role
        data['email'] = self.user.email
        data['business_name'] = self.user.business_name
        return data

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            'id', 'email', 'name', 'role',
            'phone', 'business_name', 'business_type',
            'kra_pin', 'mpesa_number', 'date_joined'
        ]
        read_only_fields = ['id', 'date_joined']

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = [
            'email', 'name', 'password', 'role',
            'business_name', 'business_type',
            'kra_pin', 'mpesa_number'
        ]

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)

class CreateCashierSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)

    class Meta:
        model = User
        fields = ['email', 'name', 'password', 'phone']

    def create(self, validated_data):
        validated_data['role'] = 'cashier'
        return User.objects.create_user(**validated_data)