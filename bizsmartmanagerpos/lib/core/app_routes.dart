
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/sales_screen.dart';
import '../screens/inventory_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/expenses_screen.dart';
import '../screens/receipts_screen.dart';
import '../screens/tax_screen.dart';
import '../screens/insights_screen.dart';

class AppRoutes {

  // Route name constants
  // Use these everywhere instead of typing '/dashboard' directly
  static const String splash    = '/';
  static const String login     = '/login';
  static const String dashboard = '/dashboard';
  static const String sales     = '/sales';
  static const String inventory = '/inventory';
  static const String reports   = '/reports';
  static const String expenses  = '/expenses';
  static const String receipts  = '/receipts';
  static const String tax       = '/tax';
  static const String insights  = '/insights';

  // Route map — Flutter reads this to know which
  // screen to show for each route name
  static Map<String, WidgetBuilder> get routes {
    return {
      splash    : (_) => const SplashScreen(),
      login     : (_) => const LoginScreen(),
      dashboard : (_) => const DashboardScreen(),
      sales     : (_) => const SalesScreen(),
      inventory : (_) => const InventoryScreen(),
      reports   : (_) => const ReportsScreen(),
      expenses  : (_) => const ExpensesScreen(),
      receipts  : (_) => const ReceiptsScreen(),
      tax       : (_) => const TaxScreen(),
      insights  : (_) => const InsightsScreen(),
    };
  }
}