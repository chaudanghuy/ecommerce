from django.urls import path, include

from . import views

urlpatterns = [
    # Customer
    path('', views.customer_index, name='home'),
    path('book', views.customer_book, name='book'),
    
    # Api
    path('api/check-available-time-slots', views.check_available_time_slots, name='check-available-time-slots'),
    
    # Test
    path('create-test-user', views.create_test_user, name='create-test-user'),
    
    # accounts
    path('account/', include('django.contrib.auth.urls')),
    path('accounts/profile/', views.admin_profile, name='profile'),
]