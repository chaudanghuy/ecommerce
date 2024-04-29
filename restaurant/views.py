from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth.models import User
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import Restaurant, Food

# Create your views here.
def index(request):
    return HttpResponse("Hello, world. You're at the restaurant index.")

# Customer
def customer_demo1(request):
    restaurant = Restaurant.objects.all()[0]
    foods = Food.objects.all()
    return render(request, 'demo/site1/index.html', {'foods': foods, 'restaurant': restaurant})

def customer_demo2(request):
    restaurant = Restaurant.objects.all()[0]
    foods = Food.objects.all()
    small_bites_foods = Food.objects.filter(category__name="SMALL BITES").all()
    main_foods = Food.objects.filter(category__name="MAINS").all()
    dessert_foods = Food.objects.filter(category__name="DESSERTS").all()
    return render(request, 'demo/site2/index.html', {'small_bites_foods': small_bites_foods, 'main_foods': main_foods, 'dessert_foods': dessert_foods,'restaurant': restaurant})

# Admin
@login_required
def admin_profile(request):
    return render(request, 'account/profile.html')

# Test
def create_test_user(request):
    user = User.objects.create_user(username='demo', password='123')
    
    user.first_name = 'Alice'
    user.last_name = 'Firstimer'
    user.save()
    return HttpResponse("Test user created.")
