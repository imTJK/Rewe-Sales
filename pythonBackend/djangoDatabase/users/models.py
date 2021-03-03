from django.db import models

# Create your models here.

class CustomUser(AbstractUser):
    EMAIL_FIELD = 'email'
    USERNAME_FIELD = 'username'
    PLZ_FIELD = 'plz'
    REQUIRED_FIELDS = ['username']
    
    username = models.CharField(blank=True, max_length=254,)
    email = models.EmailField(blank=True, max_length=254, unique=True, verbose_name="email_adress")