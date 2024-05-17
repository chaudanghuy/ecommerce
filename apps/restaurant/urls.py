from django.urls import path, include
from django.contrib.auth.views import LogoutView

from . import views
from . import apis
from . import tests
from django.views.generic.base import RedirectView

urlpatterns = [
    # Customer
    path('', views.customer_index, name='home'),
    path('book', views.customer_book, name='book'),
    path('book-table', views.customer_book_process, name='book-table'),
    path('gallery', views.customer_gallery, name='gallery'),    
    path('order', views.customer_order, name='order-online'),
    path('order-book', views.customer_order_book, name='order-book'),
    path('order-confirm', views.customer_order_confirm, name='order-confirm'),

    # Logged-in Auth
    path('admin/', RedirectView.as_view(url='/accounts/login'), name='manage'),
    path('accounts/', RedirectView.as_view(url='/accounts/login'), name='manage'),
    path('accounts/login/', views.admin_login, name='login'),
    path('accounts/logout/', LogoutView.as_view(), name='logout'),
    
    # Api
    path('api/check-available-time-slots', apis.check_available_time_slots, name='check-available-time-slots'),
    path('api/book-table', apis.book_table, name='book-api'),
    path('api/booking-events', apis.get_calendar_events, name='booking-events'),
    path('api/order', apis.order, name='order'),
    path('api/bookings', apis.get_bookings, name='bookings'),
    
    # Test
    path('create-test-user', tests.create_test_user, name='create-test-user'),
    path('test-email', tests.test_send_mail, name='test-email'),    
    
    # accounts
    path('accounts/', include('django.contrib.auth.urls')),
    path('accounts/profile/', views.admin_profile, name='profile'),
    path('accounts/calendar', views.admin_booking_tables, name='calendar'),
    path('accounts/settings/', views.admin_setting, name='setting'),    
    path('accounts/menu', views.admin_menu, name='menu'),
    path('accounts/menu-add', views.admin_menu_add, name='menu-add'),
    path('accounts/bookings', views.admin_bookings, name='bookings'),
    
    # path('delete-booking/<str:booking_id>', views.delete_booking, name='delete-booking'),
]