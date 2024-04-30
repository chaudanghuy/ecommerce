# Generated by Django 5.0.3 on 2024-04-30 15:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('restaurant', '0013_alter_booking_special_requests_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='fullname',
            field=models.CharField(default='', max_length=100),
        ),
        migrations.AlterField(
            model_name='food',
            name='availability',
            field=models.CharField(choices=[('available', 'Available'), ('unavailable', 'Unavailable')], default='available', max_length=20),
        ),
        migrations.AlterField(
            model_name='foodsub',
            name='availability',
            field=models.CharField(choices=[('available', 'Available'), ('unavailable', 'Unavailable')], default='available', max_length=20),
        ),
        migrations.AlterField(
            model_name='mytable',
            name='status',
            field=models.CharField(choices=[('available', 'Available'), ('unavailable', 'Unavailable')], default='available', max_length=20),
        ),
    ]
