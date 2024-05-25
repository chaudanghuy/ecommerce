from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Product

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'
        extra_kwargs = {'created_by': {'read_only': True}}
    
    def create(self, validated_data):
        return Product.objects.create(**validated_data)