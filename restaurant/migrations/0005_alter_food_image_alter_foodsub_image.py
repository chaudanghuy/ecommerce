# Generated by Django 5.0.3 on 2024-04-28 10:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('restaurant', '0004_booking_booking_code_booking_booking_end_time_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='food',
            name='image',
            field=models.ImageField(upload_to='food/'),
        ),
        migrations.AlterField(
            model_name='foodsub',
            name='image',
            field=models.ImageField(upload_to='food/'),
        ),
    ]
