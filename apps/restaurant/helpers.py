from django.db import models
from django.conf import settings
from google.oauth2 import service_account
import googleapiclient.discovery
from datetime import datetime as dt, timedelta
import datetime

CALENDAR_ID = settings.CALENDAR_ID
SCOPES = ["https://www.googleapis.com/auth/calendar"]
SERVICE_ACCOUNT_FILE = "./google-credentials.json"


def book_calender_api(booking_date, booking_time, duration, customer_name, customer_phone, total_people, restaurant_address, special_request):
    print("RUNNING CALENDER")
    credentials = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES
    )
    service = googleapiclient.discovery.build("calendar", "v3", credentials=credentials)

    start_datetime_str = f"{booking_date}T{booking_time}:00"
    start_datetime = dt.strptime(start_datetime_str, "%Y-%m-%dT%H:%M:%S")

    # Calculate end datetime (start datetime plus 30 minutes)
    end_datetime = start_datetime + timedelta(minutes=duration)

    new_event = {
        "summary": f'{customer_name} - {total_people} People',
        "location": f'{restaurant_address}',
        "description": f'Phone: {customer_phone} - {total_people} People - Time: {booking_time} - {special_request}',
        "start": {
            "dateTime": start_datetime.strftime("%Y-%m-%dT%H:%M:%S+01:00"),
            "timeZone": "Europe/London",
        },
        "end": {
            "dateTime": end_datetime.strftime("%Y-%m-%dT%H:%M:%S+01:00"),
            "timeZone": "Europe/London",
        },
        'colorId': '9',
        "reminders": {
            "useDefault": False,
            "overrides": [
                {"method": "email", "minutes": 24 * 60},
                {"method": "popup", "minutes": 10},
            ],
        },
    }

    print(new_event)
    service.events().insert(calendarId=CALENDAR_ID, body=new_event).execute()
    print("Event created")
