from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.models import User
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import Restaurant, Food, Booking, MyTable, User, Customer, Category
from django.conf import settings
from django.views.decorators.http import require_GET, require_POST
from datetime import datetime, timedelta
from django.views.decorators.csrf import csrf_exempt
from .enums import Status
import json
import uuid
from django.contrib import messages
import requests
import mailtrap as mt

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
    captcha_key = settings.RECAPTCHA_PUBLIC_KEY
    return render(request, 'themes/'+settings.THEME+'/book.html', {'foods': foods, 'restaurant': restaurant, 'captcha_key': captcha_key})

def customer_gallery(request):
    return render(request, 'themes/'+settings.THEME+'/gallery.html')

# API
@require_POST
@csrf_exempt
def book_table(request):
    data = json.loads(request.body.decode('utf-8'))    
    booking_date = data.get('booking_date')
    booking_time = data.get('booking_time')
    total_customer = int(data.get('total_customer'))
    duration = 90 if total_customer <= 3 else (120 if total_customer <= 6 else 150)
    tables_required = total_customer // 7 + (1 if total_customer % 7 != 0 else 0)
    
    try:
        booking_datetime = datetime.strptime(booking_date + ' ' + booking_time, '%Y-%m-%d %H:%M')
    except ValueError:
        return JsonResponse({'message': 'Invalid date or time format.'}, status=400)
    
    bookings_in_slot = Booking.objects.filter(
        booking_date__range=(booking_datetime, booking_datetime + timedelta(minutes=duration)),        
    )  
    # Remove hardcoded
    if bookings_in_slot.count() == int(settings.TOTAL_TABLE):
        return JsonResponse({'message': 'Table is already booked in this time slot.'}, status=400)    
    
    available_tables = MyTable.objects.filter(
        status=Status.AVAILABLE,
        capacity__gte=total_customer//tables_required
    ).exclude(
        id__in=[booking.table.id for booking in bookings_in_slot]
    ).distinct()            
    
    if len(available_tables) < tables_required:
        return JsonResponse({'message': 'No available table found.'}, status=400)                                  
    
    # Create user
    current_user = User.objects.filter(username=data.get('email')).first()
    if current_user is None:
        current_user = User.objects.create(
            username=data.get('email'),
            email=data.get('email'),
            password='123'
        )                   
    
    customer = Customer.objects.filter(user=current_user).first() 
    if customer is None:
        customer = Customer.objects.create(
            user=current_user,
            address=data.get('email'),
            phone=data.get('phone')
        )        
    
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
    
    return JsonResponse({'message': 'Table reserved successfully.'}, status=200)


@require_GET
def check_available_time_slots(request):
    date = request.GET.get('date')
    total_people = request.GET.get('total_people')

    if not date:
        return JsonResponse({'message': 'Date is required.'}, status=400)

    try:
        booking_date = datetime.strptime(date, '%Y-%m-%d')
    except ValueError:
        return JsonResponse({'message': 'Invalid date format. Please provide date in YYYY-MM-DD format.'}, status=400)

    try:
        total_people = int(total_people)
    except (TypeError, ValueError):
        return JsonResponse({'message': 'Total people must be a valid integer.'}, status=400)

    # Get all bookings for the given date
    bookings = Booking.objects.filter(
        booking_date=booking_date.date()
    )

    # Create a list of all booked time slots
    booked_time_slots = []
    for booking in bookings:
        start_time = booking.booking_time
        end_time = datetime.strptime(start_time, '%H:%M') + timedelta(minutes=booking.duration)
        booked_time_slots.append({
            'start_time': start_time,  # Format time in AM/PM
            'end_time': end_time.strftime('%H:%M'),
            'total_customers': booking.number_of_guests
        })    

    # Generate a list of available time slots based on total people
    available_time_slots = []
    current_time = datetime(booking_date.year, booking_date.month, booking_date.day, 8, 0)  # Assuming restaurant opens at 8:00 AM
    closing_time = datetime(booking_date.year, booking_date.month, booking_date.day, 22, 0)  # Assuming restaurant closes at 10:00 PM

    while current_time < closing_time:
        slot_start_time = current_time
        slot_end_time = current_time + timedelta(minutes=60)  # Assuming each slot is 60 minutes
        slot_already_booked = any(
            slot['start_time'] <= slot_start_time.strftime('%H:%M') <= slot['end_time']
            for slot in booked_time_slots
        )
        
        if not slot_already_booked:
            available_time_slots.append({
                'start_time': slot_start_time.strftime('%H:%M'),
                'end_time': slot_end_time.strftime('%H:%M')
            })

        current_time += timedelta(minutes=60)  # Assuming each slot is 60 minutes

    return JsonResponse({'available_time_slots': available_time_slots})

# Web 
@require_POST
@csrf_exempt
def book(request):
    if request.method == 'POST':
        data = request.POST 
        booking_date = data.get('booking_date')
        booking_time = data.get('booking_time')
        total_customer = int(data.get('total_customer'))
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
            booking_date=booking_date
        )
        
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
        
        customer = Customer.objects.filter(user=current_user).first() 
        if customer is None:
            customer = Customer.objects.create(
                user=current_user,
                address=data.get('email'),
                phone=data.get('phone')
            )        
        
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
                                               
    return HttpResponse('Your booking request was sent. We will call back or send an Email to confirm your reservation. Thank you!', status=201)

# Admin
@login_required
def admin_profile(request):
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
    )  

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
    current_time = datetime(booking_date.year, booking_date.month, booking_date.day, 10, 0)  # Assuming restaurant opens at 8:00 AM
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

        current_time += timedelta(minutes=30)  # Assuming each slot is 60 minutes

    tables = MyTable.objects.all()

    return render(request, 'account/profile.html', {'available_time_slots': available_time_slots, 'tables': tables, 'date': date, 'booked_tables': booked_tables})

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
    return render(request, 'account/setting.html', {'restaurant': restaurant})

@login_required
def admin_gallery(request):
    return render(request, 'account/gallery.html')

@login_required
def admin_menu(request):
    return render(request, 'account/menu.html')

@login_required
def admin_page(request):
    return render(request, 'account/page.html')    

# Test
def create_test_user(request):
    user = User.objects.create_user(username='demo', password='123')
    
    user.first_name = 'Alice'
    user.last_name = 'Firstimer'
    user.save()
    return HttpResponse("Test user created.")

def test_send_mail(request):
    mail = mt.Mail(
        sender=mt.Address(email="admin@phapsuit.com", name="Mailtrap Test"),
        to=[mt.Address(email="chaudanghuy6789@gmail.com")],
        subject="You are awesome!",
        text="Congrats for sending test email with Mailtrap!",
        category="Integration Test",
    )

    client = mt.MailtrapClient(token="d7d15387969eea4fe05e178fda8a7614")
    client.send(mail)
    return HttpResponse("Email sent.")