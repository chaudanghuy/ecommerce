from django.urls import path, include
from django.contrib.auth.views import LogoutView

from . import views
from django.views.generic.base import RedirectView

urlpatterns = [
    # Customer
    path('', views.customer_index, name='home'),
    path('book', views.customer_book, name='book'),
    path('book-table', views.book, name='book-table'),
    path('gallery', views.customer_gallery, name='gallery'),    

    # Account
    path('manage', RedirectView.as_view(url='/accounts/login'), name='manage'),
    path('accounts', RedirectView.as_view(url='/accounts/login'), name='login'),
    path('accounts/logout/', LogoutView.as_view(), name='logout'),
    
    # Api
    path('api/check-available-time-slots', views.check_available_time_slots, name='check-available-time-slots'),
    path('api/book-table', views.book_table, name='book-api'),
    
    # Test
    path('create-test-user', views.create_test_user, name='create-test-user'),
    path('test-email', views.test_send_mail, name='test-email'),
    
    # accounts
    path('accounts/', include('django.contrib.auth.urls')),
    path('accounts/profile/', views.admin_profile, name='profile'),
    path('accounts/settings/', views.admin_setting, name='setting'),
    path('accounts/gallery', views.admin_gallery, name='gallery'),
    path('accounts/menu', views.admin_menu, name='menu'),
    path('accounts/pages', views.admin_page, name='page'),
]