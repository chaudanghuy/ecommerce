from django.urls import path, include

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    
    # demo
    path('demo1', views.customer_demo1, name='demo1'),
    path('demo2', views.customer_demo2, name='demo2'),
    
    # Test
    path('create-test-user', views.create_test_user, name='create-test-user'),
    
    # accounts
    path('accounts/', include('django.contrib.auth.urls')),
    path('accounts/profile/', views.admin_profile, name='profile'),
]