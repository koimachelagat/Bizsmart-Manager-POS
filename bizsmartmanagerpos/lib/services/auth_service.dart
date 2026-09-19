// lib/services/auth_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/app_constants.dart';

class AuthService extends ChangeNotifier {

  // ─────────────────────────────────────────
  // STORAGE & STATE
  // ─────────────────────────────────────────

  final _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _userRole;
  String? get userRole => _userRole;

  String? _userName;
  String? get userName => _userName;

  // ─────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.instance.dio.post(
        'auth/token/',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Save tokens securely
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: response.data['access'],
      );
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: response.data['refresh'],
      );
      await _storage.write(
        key: AppConstants.userRoleKey,
        value: response.data['role'],
      );
      await _storage.write(
        key: AppConstants.userNameKey,
        value: response.data['name'],
      );

      // Update in-memory values
      _userRole = response.data['role'];
      _userName = response.data['name'];

      return true;

    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _errorMessage = 'Invalid email or password.';
      } else if (e.response?.statusCode == 400) {
        _errorMessage = 'Please enter a valid email and password.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        _errorMessage = 'Cannot reach server. Check your connection.';
      } else {
        _errorMessage = 'Something went wrong. Please try again.';
      }

      return false;

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────
  // CHECK IF LOGGED IN
  // Called by splash_screen.dart on app launch
  // ─────────────────────────────────────────

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(
      key: AppConstants.accessTokenKey,
    );

    if (token != null) {
      _userRole = await _storage.read(key: AppConstants.userRoleKey);
      _userName = await _storage.read(key: AppConstants.userNameKey);
    }

    return token != null;
  }

  // ─────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userRoleKey);
    await _storage.delete(key: AppConstants.userNameKey);

    _userRole = null;
    _userName = null;
    _errorMessage = null;

    notifyListeners();
  }

  // ─────────────────────────────────────────
  // ROLE HELPERS
  // ─────────────────────────────────────────

  bool get isAdmin => _userRole == AppConstants.roleAdmin;
  bool get isCashier => _userRole == AppConstants.roleCashier;
}