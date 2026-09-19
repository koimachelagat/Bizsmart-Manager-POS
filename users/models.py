# users/models.py

from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models


class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Email is required')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('role', 'admin')
        return self.create_user(email, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):

    ROLE_CHOICES = [
        ('admin', 'Admin'),
        ('cashier', 'Cashier'),
    ]

    # Core fields
    email           = models.EmailField(unique=True)
    name            = models.CharField(max_length=255)
    role            = models.CharField(max_length=20, choices=ROLE_CHOICES, default='cashier')
    phone           = models.CharField(max_length=20, blank=True)

    # Business info — set during onboarding
    business_name   = models.CharField(max_length=255, blank=True)
    business_type   = models.CharField(max_length=100, blank=True)
    kra_pin         = models.CharField(max_length=20, blank=True)
    mpesa_number    = models.CharField(max_length=20, blank=True)

    # Status
    is_active       = models.BooleanField(default=True)
    is_staff        = models.BooleanField(default=False)
    date_joined     = models.DateTimeField(auto_now_add=True)
    last_login      = models.DateTimeField(null=True, blank=True)

    objects = UserManager()

    # Use email instead of username to login
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    class Meta:
        db_table = 'users'
        verbose_name = 'User'
        verbose_name_plural = 'Users'

    def __str__(self):
        return f'{self.name} ({self.email})'

    @property
    def is_admin(self):
        return self.role == 'admin'

    @property
    def is_cashier(self):
        return self.role == 'cashier'