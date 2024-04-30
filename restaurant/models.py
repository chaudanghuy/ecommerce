from django.db import models
from django.contrib.auth.models import AbstractUser
from .enums import Status, BookingStatus
import uuid

# Create your models here.
class Restaurant(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100)
    address = models.TextField()
    phone = models.CharField(max_length=20)
    email = models.CharField(max_length=100)
    description = models.TextField()
    opening_hours = models.TextField()
    
    def __str__(self) -> str:
        return self.name
    
class User(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    fullname = models.CharField(max_length=100, default='')
    username = models.CharField(max_length=100)
    password = models.CharField(max_length=100)
    email = models.CharField(max_length=100)    
    
    def __str__(self) -> str:
        return self.username

class Customer(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    address = models.TextField()
    phone = models.CharField(max_length=20)
    
    def __str__(self) -> str:
        return self.user_id
    
class MyTable(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    table_number = models.CharField(max_length=10)
    capacity = models.IntegerField()
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.AVAILABLE)    
    
class Booking(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    table = models.ForeignKey(MyTable, on_delete=models.CASCADE)
    booking_code = models.CharField(max_length=100,  default=uuid.uuid4)
    booking_date = models.DateField()
    booking_time = models.TextField()
    duration = models.IntegerField(default=90)
    number_of_guests = models.IntegerField()
    booking_status = models.CharField(max_length=20, choices=BookingStatus.choices, default=BookingStatus.PENDING)
    special_requests = models.TextField(default='')
    total_price = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    tax = models.IntegerField(default=0) 
    booking_end_time = models.TimeField(default='23:59:59')
    
    def __str__(self) -> str:
        return self.booking_code

class Menu(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    description = models.TextField()
    
    def __str__(self) -> str:
        return self.name

class Translation(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    language = models.CharField(max_length=10)
    code = models.CharField(max_length=10)    
    description = models.TextField()      
    
    def __str__(self) -> str:
        return self.language

class Category(models.Model):
    id =  models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    translation = models.ForeignKey(Translation, on_delete=models.CASCADE)
    filter_code = models.CharField(max_length=55, default='')
    menu_id = models.ForeignKey(Menu, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)    
    
    def __str__(self) -> str:
        return self.name
    
class CategorySub(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    translation = models.ForeignKey(Translation, on_delete=models.CASCADE)
    category_id = models.ForeignKey(Category, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)    
    
    def __str__(self) -> str:
        return self.name    
    
class Food(models.Model): 
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    translation = models.ForeignKey(Translation, on_delete=models.CASCADE)  
    category = models.ForeignKey(Category, default=1, on_delete=models.CASCADE)  
    category_sub = models.ForeignKey(CategorySub, on_delete=models.CASCADE, blank=True, null=True)   
    name = models.CharField(max_length=100)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='food/')
    availability = models.CharField(max_length=20, choices=Status.choices, default=Status.AVAILABLE)     
    
    def __str__(self) -> str:
        return self.name

class FoodSub(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    translation = models.ForeignKey(Translation, on_delete=models.CASCADE)
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='food/')
    availability = models.CharField(max_length=20, choices=Status.choices, default=Status.AVAILABLE)
    
    def __str__(self) -> str:        
        return self.name
    
class BookingDetail(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    quantity = models.IntegerField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    food_sub = models.ForeignKey(FoodSub, on_delete=models.CASCADE, blank=True, null=True)
    food_sub_quantity = models.IntegerField(blank=True, null=True)
    food_sub_price = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    deleted_at = models.DateTimeField(blank=True, null=True)
    
    def __str__(self) -> str:
        return self.booking_id    