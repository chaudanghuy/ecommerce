from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.models import User
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import Restaurant, Food, Booking
from django.conf import settings
from django.views.decorators.http import require_GET
from datetime import datetime, timedelta

# Create your views here.
def index(request):
    return HttpResponse("Hello, world. You're at the restaurant index.")

# Customer
def customer_index(request):
    restaurant = Restaurant.objects.all()[0]
    foods = Food.objects.all()
    return render(request, 'themes/'+settings.THEME+'/index.html', {'foods': foods, 'restaurant': restaurant})

def customer_book(request):
    restaurant = Restaurant.objects.all()[0]
    foods = Food.objects.all()
    return render(request, 'themes/'+settings.THEME+'/book.html', {'foods': foods, 'restaurant': restaurant})

# API
@require_GET
def check_available_time_slots(request):
    date = request.GET.get('date')
    total_people = request.GET.get('total_people')
    
    if not date:
        return JsonResponse({'message': 'Please provide date.'}, status=400)
    
    try:
        booking_date = datetime.strptime(date, '%Y-%m-%d')
    except ValueError:
        return JsonResponse({'message': 'Invalid date format.'}, status=400)
    
    try:
        total_people = int(total_people)
    except (TypeError, ValueError):
        return JsonResponse({'message': 'Invalid total people.'}, status=400)
    
    bookings = Booking.objects.filter(
        booking_date__date=booking_date.date()
    )   
        

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
