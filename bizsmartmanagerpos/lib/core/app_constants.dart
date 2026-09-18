// lib/core/app_constants.dart

class AppConstants {

  // ─────────────────────────────────────────
  // API — Your Django backend URL
  // Change this IP to your Django server address
  // When running Django locally: python manage.py runserver
  // It starts on http://127.0.0.1:8000
  // ─────────────────────────────────────────
  static const String baseUrl = 'http://127.0.0.1:8000/api/';

  // ─────────────────────────────────────────
  // KRA TAX CONSTANTS
  // These are Kenya Revenue Authority official rates
  // ─────────────────────────────────────────
  static const double vatRate           = 0.16;  // 16% VAT
  static const double withholdingTax    = 0.05;  // 5% Withholding Tax
  static const double exciseDuty        = 0.10;  // 10% Excise Duty

  // ─────────────────────────────────────────
  // CURRENCY
  // ─────────────────────────────────────────
  static const String currency          = 'KES';
  static const String currencySymbol    = 'KSh';

  // ─────────────────────────────────────────
  // SECURE STORAGE KEYS
  // These are the key names used to store
  // JWT tokens securely on the device
  // Think of them as variable names for your safe/vault
  // ─────────────────────────────────────────
  static const String accessTokenKey    = 'access_token';
  static const String refreshTokenKey   = 'refresh_token';
  static const String userRoleKey       = 'user_role';
  static const String userNameKey       = 'user_name';

  // ─────────────────────────────────────────
  // USER ROLES
  // These match exactly what Django sends back
  // after login — don't change the spelling
  // ─────────────────────────────────────────
  static const String roleAdmin         = 'admin';
  static const String roleCashier       = 'cashier';

  // ─────────────────────────────────────────
  // PAGINATION
  // How many items to load per page in lists
  // ─────────────────────────────────────────
  static const int pageSize             = 20;

  // ─────────────────────────────────────────
  // BUSINESS LOGIC
  // ─────────────────────────────────────────

  // Minimum stock level before a low stock alert fires
  static const int lowStockThreshold   = 10;

  // How often the AI insights refresh (in minutes)
  static const int insightRefreshMins  = 30;
}