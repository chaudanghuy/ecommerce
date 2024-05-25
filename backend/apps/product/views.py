from django.shortcuts import render
from rest_framework import generics
from .serializers import ProductSerializer
from rest_framework.permissions import IsAuthenticated, AllowAny
from .models import Product

# Create your views here.
class ProductListCreate(generics.ListCreateAPIView):
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Product.objects.filter(created_by=user)
    
    def perform_create(self, serializer):
        