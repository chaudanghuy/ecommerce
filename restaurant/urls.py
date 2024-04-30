from django.urls import path, include

from . import views

urlpatterns = [
    # Customer
    path('', views.customer_index, name='home'),
    path('book', views.customer_book, name='book'),
    path('book-table', views.book, name='book-table'),
    
    # Api
    path('api/check-available-time-slots', views.check_available_time_slots, name='check-available-time-slots'),
    path('api/book-table', views.book_table, name='book-api'),
    
    # Test
    path('create-test-user', views.create_test_user, name='create-test-user'),
    
    # accounts
    path('account/', include('django.contrib.auth.urls')),
    path('accounts/profile/', views.admin_profile, name='profile'),
]