from django.test import TestCase
from .models import User
from django.http.response import HttpResponse
from . import helpers
import mailtrap as mt

# Create your tests here.
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

def test_calender(request):
    helpers.book_calender_api(request.GET.get('date'), request.GET.get('time'))
    return HttpResponse("Calendar created.")