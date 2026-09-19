// lib/core/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_constants.dart';


class ApiClient {

  // ─────────────────────────────────────────
  // SINGLETON — one shared instance for the whole app
  // ─────────────────────────────────────────
  static final ApiClient instance = ApiClient._internal();
  ApiClient._internal();

  // The Dio HTTP client — initialized in init()
  late Dio dio;

  // Secure storage — reads JWT tokens from device vault
  final _storage = const FlutterSecureStorage();

  // ─────────────────────────────────────────
  // INITIALIZE — called once in main.dart
  // ─────────────────────────────────────────
  void init() {
    dio = Dio(BaseOptions(
      // Base URL — all requests start from here
      baseUrl: AppConstants.baseUrl,

      // Timeout settings
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),

      // Default headers for every request
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // ── JWT INTERCEPTOR ──
    // Automatically attaches token to every request
    // and silently refreshes it when it expires
    dio.interceptors.add(
      InterceptorsWrapper(

        // Runs BEFORE every request is sent
        onRequest: (options, handler) async {
          final token = await _storage.read(
            key: AppConstants.accessTokenKey,
          );

          // Attach token if it exists
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },

        // Runs WHEN an error occurs
        onError: (error, handler) async {
          // 401 = token expired
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();

            if (refreshed) {
              // Retry the original request with new token
              final response = await dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  // ─────────────────────────────────────────
  // REFRESH TOKEN
  // Called automatically on 401 errors
  // ─────────────────────────────────────────
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(
        key: AppConstants.refreshTokenKey,
      );

      if (refreshToken == null) return false;

      final response = await dio.post(
        'auth/token/refresh/',
        data: {'refresh': refreshToken},
      );

      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: response.data['access'],
      );

      return true;

    } catch (_) {
      return false;
    }
  }
}