from django.db import models
from django.utils.translation import gettext_lazy as _

class Status(models.TextChoices):
    AVAILABLE = 'available', _('Available')
    UNAVAILABLE = 'unavailable', _('Unavailable')
    
class BookingStatus(models.TextChoices):
    PENDING = 'pending', _('Pending')
    CONFIRMED = 'confirmed', _('Confirmed')
    CANCELLED = 'cancelled', _('Cancelled')    