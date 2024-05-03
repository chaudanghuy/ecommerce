from django.http import HttpResponse, JsonResponse
from django.views.decorators.http import require_POST, require_GET
from django.views.decorators.csrf import csrf_exempt
from datetime import datetime, timedelta
from .models import Booking, MyTable, User, Customer, Restaurant, Food, Category
from .enums import Status
from . import helpers
from django.conf import settings
import uuid
import json

# API
@require_POST
@csrf_exempt
def book_table(request):
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
            return JsonResponse('Invalid booking date or time.', status=400, safe=False)        
        
        end_time_check = (booking_datetime + timedelta(minutes=duration)).strftime('%H:%M')
        if booking_datetime.hour >= 22:
            return JsonResponse('We are fully booked at this time', status=400, safe=False)        
        
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
            return JsonResponse('We are fully booked at this time.', status=400, safe=False)
        
        available_tables = MyTable.objects.filter(
            status=Status.AVAILABLE,
            capacity__gte=total_customer//tables_required
        ).exclude(
            id__in=[booking.table.id for booking in bookings_in_slot]
        ).distinct()            
        
        if len(available_tables) < tables_required:
            return JsonResponse('We are fully booked at this time', status=400, safe=False)                          
        
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
    return JsonResponse({
        'message': 'Your booking request was sent. We will call back or send an Email to confirm your reservation. Thank you!',
        'booking_datetime': booking_datetime.strftime('%Y-%m-%d %H:%M'),
        'booking_reference': booking_code,
        'booking_date': booking_date,
        'booking_time': booking_time,
        'num_guests': total_customer,
        'special_requests': special_request,
        'reply_to': data.get('email'),
    }, status=200, safe=False)


@require_GET
def check_available_time_slots(request):
    date = request.GET.get('date')
    total_people = request.GET.get('total_people')

    if not date:
        return JsonResponse({'message': 'Date is required.'}, status=500)

    try:
        booking_date = datetime.strptime(date, '%Y-%m-%d')
    except ValueError:
        return JsonResponse({'message': 'Invalid date format. Please provide date in YYYY-MM-DD format.'}, status=500)

    try:
        total_people = int(total_people)
    except (TypeError, ValueError):
        return JsonResponse({'message': 'Total people must be a valid integer.'}, status=500)

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


@require_POST
@csrf_exempt
def edit_food(request):
    if request.method == 'POST':
        food_id = request.POST.get('food_id')
        name = request.POST.get('name')
        price = request.POST.get('price')        
        category_id = request.POST.get('category')
        if category_id:
            category = Category.objects.get(pk=category_id)
        else:
            return JsonResponse({'message': 'Category is required.'}, status=400)
        description = request.POST.get('description')
        is_available = request.POST.get('is_available')

        image = request.FILES.get('image')

        if food_id:
            food = Food.objects.get(pk=food_id)
        else:
            food = Food()
        
        food.name = name
        food.price = price
        food.category = category
        food.description = description
        if is_available == 'true':
            food.availability = "available"
        else:
            food.availability = "unavailable"        

        if image:
            food.image = image

        food.save()

        return JsonResponse({'message': 'Food saved successfully.'})
    else:
        return JsonResponse({'message': 'Invalid request.'}, status=400)

