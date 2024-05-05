from django import forms
from .models import Food

class FoodForm(forms.ModelForm):
  class Meta:
        model = Food
        fields = ['category','name', 'description', 'price', 'image', 'availability', 'translation_id']