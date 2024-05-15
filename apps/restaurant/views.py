from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.models import User
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import Restaurant, Food, Booking, MyTable, User, Customer, Category, Translation
from django.conf import settings
from django.views.decorators.http import require_GET, require_POST
from datetime import datetime, timedelta
from django.views.decorators.csrf import csrf_exempt
from .enums import Status
import json
import uuid
from django.contrib import messages
import requests
from . import helpers
from django.shortcuts import get_object_or_404, redirect
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from .forms import FoodForm

# Frontend
def index(request):
    return HttpResponse("Hello, world. You're at the restaurant index.")

def customer_index(request):
    restaurant = Restaurant.objects.all()[0]
    foods = Food.objects.filter(availability='available')  # Filter for availability only
    categories = Category.objects.all()
    return render(request, 'themes/'+settings.THEME+'/index.html', {'foods': foods, 'restaurant': restaurant, 'categories': categories})

def customer_book(request):
    restaurant = Restaurant.objects.all()[0]
    foods = Food.objects.all()
    captcha_key = settings.RECAPTCHA_PUBLIC_KEY
    return render(request, 'themes/'+settings.THEME+'/book.html', {'foods': foods, 'restaurant': restaurant, 'captcha_key': captcha_key})

def customer_gallery(request):
    return render(request, 'themes/'+settings.THEME+'/gallery.html')

def customer_order(request):
    restaurant = Restaurant.objects.all()[0]
    foods = Food.objects.filter(availability='available')  # Filter for availability only
    return render(request, 'themes/'+settings.THEME+'/order.html', {'foods': foods, 'restaurant': restaurant})

def customer_order_book(request):
    restaurant = Restaurant.objects.all()[0]
    foods = Food.objects.filter(availability='available')  # Filter for availability only
    return render(request, 'themes/'+settings.THEME+'/order_book.html', {'foods': foods, 'restaurant': restaurant})

def customer_order_confirm(request):
    restaurant = Restaurant.objects.all()[0]
    return render(request, 'themes/'+settings.THEME+'/order_confirmation.html', {'restaurant': restaurant})

# Web 
@require_POST
@csrf_exempt
def customer_book_process(request):
    if request.method == 'POST':
        data = request.POST 
        booking_date = data.get('booking_date')
        booking_time = data.get('booking_time')
        total_customer = int(data.get('total_customer'))
        special_request = data.get('special_requests')
        duration = 90 if total_customer <= 3 else (120 if total_customer <= 6 else 150)
        tables_required = total_customer // 7 + (1 if total_customer % 7 != 0 else 0)
        
        try:
            booking_datetime = datetime.strptime(booking_date + ' ' + booking_time, '%Y-%m-%d %H:%M')
        except ValueError:
            return HttpResponse('Invalid booking date or time.')        
        
        end_time_check = (booking_datetime + timedelta(minutes=duration)).strftime('%H:%M')
        if booking_datetime.hour >= 22:
            return HttpResponse('We are fully booked at this time')        
        
        # Get all bookings for the given date
        bookings = Booking.objects.filter(
            booking_date=booking_date.date()
        ).exclude(customer__address__icontains='pickup-order').exclude(special_requests='delivery-order')    
        
        bookings_in_slot = []
        for booking in bookings:
            start_time_booking = booking.booking_time
            end_time_booking = (datetime.strptime(booking.booking_time, '%H:%M') + timedelta(minutes=booking.duration)).strftime('%H:%M')
            
            end_time = (booking_datetime + timedelta(minutes=duration)).strftime('%H:%M')
            if start_time_booking <= booking_time <= end_time_booking:
                bookings_in_slot.append(booking)   
            elif booking_time <= start_time_booking <= end_time:
                bookings_in_slot.append(booking)                                    
                
        # Remove hardcoded
        if bookings_in_slot and len(bookings_in_slot) > int(settings.TOTAL_TABLE):
            return HttpResponse('We are fully booked at this time.')
        
        available_tables = MyTable.objects.filter(
            status=Status.AVAILABLE,
            capacity__gte=total_customer//tables_required
        ).exclude(
            id__in=[booking.table.id for booking in bookings_in_slot]
        ).distinct()            
        
        if len(available_tables) < tables_required:
            return HttpResponse('We are fully booked at this time')                          
        
        # Create user
        current_user = User.objects.filter(username=data.get('email')).first()
        if current_user is None:
            current_user = User.objects.create(
                fullname=data.get('fullname'),
                username=data.get('email'),
                email=data.get('email'),
                password='123'
            )                   
        else:
            current_user.fullname = data.get('fullname')
            current_user.username = data.get('email')
            current_user.email = data.get('email')
            current_user.save()
        
        customer = Customer.objects.filter(user=current_user).first() 
        if customer is None:
            customer = Customer.objects.create(
                user=current_user,
                address=data.get('email'),
                phone=data.get('phone')
            )
        else:
            customer.address = data.get('email')
            customer.phone = data.get('phone')
            customer.save()        
        
        booking_code = uuid.uuid4()
        for i in range(tables_required):
            table = available_tables[i]        
            booking = Booking.objects.create(
                customer=customer,
                table=table,
                booking_date=booking_date,
                booking_time=booking_time,
                booking_code=booking_code,
                duration=duration,
                number_of_guests=total_customer,
                special_requests=data.get('special_requests'),
            ) 
    
    restaurant = Restaurant.objects.all()[0]
    # Call Calender API
    helpers.book_calender_api(booking_date, booking_time, duration, data.get('fullname'), data.get('phone'), total_customer, restaurant.address, special_request)
    return HttpResponse('Your booking request was sent. We will call back or send an Email to confirm your reservation. Thank you!', status=201)

# Admin
@login_required
def admin_calendar(request):
    date = request.GET.get('date')
    
    try:
        date = datetime.strptime(date, '%Y-%m-%d').strftime('%Y-%m-%d')
    except (TypeError, ValueError):
        try:
            date = datetime.strptime(date, '%m/%d/%Y').strftime('%Y-%m-%d')
        except (TypeError, ValueError):
            date = datetime.today().strftime('%Y-%m-%d')
    
    if not date:
        date = datetime.today().strftime('%Y-%m-%d')

    if not date:
        return JsonResponse({'message': 'Date is required.'}, status=400)

    try:
        booking_date = datetime.strptime(date, '%Y-%m-%d')
    except ValueError:
        return JsonResponse({'message': 'Invalid date format. Please provide date in YYYY-MM-DD format.'}, status=400)

    # Get all bookings for the given date
    bookings = Booking.objects.filter(
        booking_date=booking_date.date()
    ).exclude(customer__address__icontains='pickup-order').exclude(special_requests='delivery-order')

    # Create a list of all booked time slots
    booked_tables = []
    booked_time_slots = []
    for booking in bookings:
        start_time = booking.booking_time
        end_time = datetime.strptime(start_time, '%H:%M') + timedelta(minutes=booking.duration)
        booked_time_slots.append({
            'start_time': start_time,  # Format time in AM/PM
            'end_time': end_time.strftime('%H:%M'),
            'total_customers': booking.number_of_guests,
            'table': booking.table.table_number,
            'booking_code': booking.booking_code,
            'booking_phone': booking.table.table_number + '-' + str(booking.customer.phone),
            'number_of_guests': booking.table.table_number + '-' + str(booking.number_of_guests),
            'booking_name': booking.table.table_number + '-' +  str(booking.customer.user.email)
        })

    # Generate a list of available time slots based on total people
    available_time_slots = []
    current_time = datetime(booking_date.year, booking_date.month, booking_date.day, 17, 0)  # Assuming restaurant opens at 17:00 PM
    closing_time = datetime(booking_date.year, booking_date.month, booking_date.day, 22, 0)  # Assuming restaurant closes at 10:00 PM

    table_codes_with_id = []
    while current_time < closing_time:
        slot_start_time = current_time
        slot_end_time = current_time + timedelta(minutes=60)  # Assuming each slot is 60 minutes
        
        slot_already_booked = any(
            slot['start_time'] <= slot_start_time.strftime('%H:%M') <= slot['end_time']
            for slot in booked_time_slots
        )

        
        table_booked = [slot['table'] for slot in booked_time_slots if
                        slot['start_time'] <= slot_start_time.strftime('%H:%M') <= slot['end_time']]
        table_codes = [slot['booking_code'] for slot in booked_time_slots if
                       slot['start_time'] <= slot_start_time.strftime('%H:%M') <= slot['end_time']]
        table_book_phones = [slot['booking_phone'] for slot in booked_time_slots if
                             slot['start_time'] <= slot_start_time.strftime('%H:%M') <= slot['end_time']]
        table_book_total_guests = [slot['number_of_guests'] for slot in booked_time_slots if
                                   slot['start_time'] <= slot_start_time.strftime('%H:%M') <= slot['end_time']]         
        table_book_name = [slot['booking_name'] for slot in booked_time_slots if
                           slot['start_time'] <= slot_start_time.strftime('%H:%M') <= slot['end_time']]  
    
        print(table_book_phones)
                    
        if not slot_already_booked:
            available_time_slots.append({
                'start_time': slot_start_time.strftime('%H:%M'),
                'end_time': slot_end_time.strftime('%H:%M'),
                'flag': 'not-booked',
                'booking_phone': slot_start_time.strftime('%H:%M')
            })
        else:
            available_time_slots.append({
                'start_time': slot_start_time.strftime('%H:%M'),
                'end_time': slot_end_time.strftime('%H:%M'),
                'flag': 'booked',
                'table': table_booked,
                'booking_code': table_codes,
                'booking_phone':table_book_phones,
                'number_of_guests': table_book_total_guests,
                'table_book_name': table_book_name
            })

        current_time += timedelta(minutes=15)  # Assuming each slot is 60 minutes

    tables = MyTable.objects.all()
    
    booking_lists = Booking.objects.filter(
        booking_date=booking_date.date()
    ).exclude(customer__address__icontains='pickup-order').exclude(special_requests='delivery-order')

    return render(request, 'admin/admin_calendar.html', {'available_time_slots': available_time_slots, 'tables': tables, 'date': date, 'booked_tables': booked_tables, 'booking_lists': booking_lists})

@login_required
def admin_profile(request):
    restaurant = Restaurant.objects.first()
    current_user = request.user  # Get the current logged-in user
    if request.method == 'POST':                
        restaurant.name = request.POST.get('name')
        restaurant.address = request.POST.get('address')
        restaurant.phone = request.POST.get('phone')
        restaurant.email = request.POST.get('email')
        restaurant.description = request.POST.get('description')
        restaurant.opening_hours = request.POST.get('opening_hours')
        restaurant.save()
    return render(request, 'admin/admin_profile.html', {'restaurant': restaurant, 'current_user': current_user})

@login_required
def admin_setting(request):
    restaurant = Restaurant.objects.first()
    if request.method == 'POST':                
        restaurant.name = request.POST.get('name')
        restaurant.address = request.POST.get('address')
        restaurant.phone = request.POST.get('phone')
        restaurant.email = request.POST.get('email')
        restaurant.description = request.POST.get('description')
        restaurant.opening_hours = request.POST.get('opening_hours')
        restaurant.save()
    return render(request, 'admin/admin_setting.html', {'restaurant': restaurant})

@login_required
def admin_gallery(request):
    return render(request, 'admin/admin_gallery.html')

@login_required
@csrf_exempt
def admin_menu(request):
    categories = Category.objects.all()
    foods = Food.objects.order_by('-id')
    food_id = request.GET.get('food')
    transalations = Translation.objects.all()
    if food_id:
        food = Food.objects.get(id=food_id)
        if request.method == 'POST':
            form = FoodForm(request.POST, request.FILES, instance=food)
            if form.is_valid():
                form.save()
        return render(request, 'admin/admin_menu_edit.html', {'categories': categories, 'food': food, 'transalations': transalations})      
    else:
        return render(request, 'admin/admin_menu.html', {'categories': categories, 'foods': foods, 'transalations': transalations})

@login_required
@csrf_exempt
def admin_menu_add(request):
    categories = Category.objects.all()    
    transalations = Translation.objects.all()
    if request.method == 'POST':
        form = FoodForm(request.POST, request.FILES)
        if 'en' in [t.language for t in transalations]:
            default_translation_id = [t.id for t in transalations if t.language=='en'][0]
        else:
            default_translation_id = transalations[0].id
        form.initial['translation_id'] = default_translation_id
        
        if form.is_valid():
            form.save()
            return redirect('menu')
    else:
        form = FoodForm()
    return render(request, 'admin/admin_menu_add.html', {'form': form, 'categories': categories, 'transalations': transalations})

@login_required
@csrf_exempt    
def admin_developer_setting(request):    
    return render(request, 'admin/admin_developer_setting.html')

@csrf_exempt
def delete_booking(request, booking_id):
    booking = Booking.objects.get(id=booking_id)
    booking.delete()
    return JsonResponse({'message': 'Booking deleted successfully!'})

@login_required
def admin_bookings(request):
    bookings = Booking.objects.order_by('-id')
    return render(request, 'admin/admin_bookings.html', {'bookings': bookings}) 