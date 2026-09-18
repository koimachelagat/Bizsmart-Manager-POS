// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../core/app_routes.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Show splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final auth = context.read<AuthService>();
    final isLoggedIn = await auth.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // Has saved token — go to dashboard
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else {
      // Check if business setup was ever completed
      final setupComplete = await _getSetupComplete();

      if (!mounted) return;

      if (setupComplete) {
        // Setup done before — go to login
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        // Very first time — go to onboarding wizard
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    }
  }

  // Reads the setup_complete flag from device storage
  Future<bool> _getSetupComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Returns false if flag doesn't exist yet (first time)
      return prefs.getBool('setup_complete') ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.point_of_sale_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'BizSmart Manager',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'AI-Powered POS for Kenyan SMEs',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 60),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
              const SizedBox(height: 24),
              const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}