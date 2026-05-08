import 'dart:async';
import 'package:dio/dio.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';

/// Background service to handle automatic token refresh
/// Runs in the background and refreshes tokens before expiration
class BackgroundTokenRefreshService {
  static final BackgroundTokenRefreshService _instance =
      BackgroundTokenRefreshService._internal();

  factory BackgroundTokenRefreshService() {
    return _instance;
  }

  BackgroundTokenRefreshService._internal();

  Timer? _refreshTimer;
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://smartjop.runasp.net',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Start the background token refresh service
  /// Checks every [checkIntervalMinutes] if token needs refresh
  void startBackgroundRefresh({int checkIntervalMinutes = 5}) {
    // Cancel existing timer if any
    _refreshTimer?.cancel();

    // Check immediately on start
    _checkAndRefreshTokenIfNeeded();

    // Set up periodic checks
    _refreshTimer = Timer.periodic(
      Duration(minutes: checkIntervalMinutes),
      (_) {
        _checkAndRefreshTokenIfNeeded();
      },
    );
  }

  /// Stop the background refresh service
  void stopBackgroundRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Check if token needs refresh and refresh if needed
  /// Refresh if token expires within the next 2 minutes
  Future<void> _checkAndRefreshTokenIfNeeded() async {
    try {
      final expiresAtUtcStr = CacheHelper.getData(key: 'expiresAtUtc');
      if (expiresAtUtcStr == null) return;

      final expiresAt = DateTime.parse(expiresAtUtcStr);
      final now = DateTime.now().toUtc();
      final timeUntilExpiry = expiresAt.difference(now);

      // Refresh if expiring within 2 minutes
      if (timeUntilExpiry.inSeconds < 120) {
        await refreshToken();
      }
    } catch (e) {
      print('Error checking token expiry: $e');
    }
  }

  /// Manually trigger token refresh
  Future<bool> refreshToken() async {
    try {
      final refreshToken = CacheHelper.getData(key: 'refreshToken');

      if (refreshToken == null || refreshToken.isEmpty) {
        print('No refresh token available');
        return false;
      }

      final response = await _dio.post(
        '/api/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await CacheHelper.saveData(
          key: 'accessToken',
          value: response.data['accessToken'],
        );
        await CacheHelper.saveData(
          key: 'refreshToken',
          value: response.data['refreshToken'],
        );
        await CacheHelper.saveData(
          key: 'expiresAtUtc',
          value: response.data['expiresAtUtc'],
        );

        print('Token refreshed successfully');
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Failed to refresh token: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error during token refresh: $e');
      return false;
    }
  }

  /// Clear all stored tokens
  Future<void> clearTokens() async {
    await CacheHelper.removeData(key: 'accessToken');
    await CacheHelper.removeData(key: 'refreshToken');
    await CacheHelper.removeData(key: 'expiresAtUtc');
  }

  /// Check if user is currently authenticated
  bool isAuthenticated() {
    final accessToken = CacheHelper.getData(key: 'accessToken');
    return accessToken != null && accessToken.isNotEmpty;
  }
}
