import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    if (kDebugMode) {
      print('BackgroundTokenRefreshService: Starting background refresh service');
    }
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
    if (kDebugMode) {
      print('BackgroundTokenRefreshService: Stopping background refresh service');
    }
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Check if token needs refresh and refresh if needed
  /// Refresh if token expires within the next 2 minutes
  Future<void> _checkAndRefreshTokenIfNeeded() async {
    if (kDebugMode) {
      print('BackgroundTokenRefreshService: Checking if token needs refresh');
    }
    try {
      final expiresAtUtcStr = CacheHelper.getData(key: 'expiresAtUtc');
      if (expiresAtUtcStr == null) {
        if (kDebugMode) {
          print('BackgroundTokenRefreshService: No expiresAtUtc found');
        }
        return;
      }

      final expiresAt = DateTime.parse(expiresAtUtcStr);
      final now = DateTime.now().toUtc();
      final timeUntilExpiry = expiresAt.difference(now);

      if (kDebugMode) {
        print('BackgroundTokenRefreshService: Time until expiry: $timeUntilExpiry');
      }
      // Refresh if expiring within 2 minutes
      if (timeUntilExpiry.inSeconds < 120) {
        if (kDebugMode) {
          print('BackgroundTokenRefreshService: Token is expiring soon, initiating refresh');
        }
        await refreshToken();
      }
    } catch (e) {
      if (kDebugMode) {
        print('BackgroundTokenRefreshService: Error while checking for token refresh: $e');
      }
      // Ignore background refresh initialization errors silently.
    }
  }

  /// Manually trigger token refresh
  Future<bool> refreshToken() async {
    if (kDebugMode) {
      print('BackgroundTokenRefreshService: Initiating manual token refresh');
    }
    try {
      final refreshToken = CacheHelper.getData(key: 'refreshToken');

      if (refreshToken == null || refreshToken.isEmpty) {
        if (kDebugMode) {
          print('BackgroundTokenRefreshService: No refresh token found');
        }
        await clearTokens();
        return false;
      }

      final response = await _dio.post(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('BackgroundTokenRefreshService: Token refresh successful');
        }
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

        return true;
      }
      if (kDebugMode) {
        print('BackgroundTokenRefreshService: Token refresh failed with status code ${response.statusCode}');
      }
      await clearTokens();
      return false;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('BackgroundTokenRefreshService: Token refresh failed: $e');
      }
      await clearTokens();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('BackgroundTokenRefreshService: Token refresh failed with unexpected error: $e');
      }
      await clearTokens();
      return false;
    }
  }

  /// Clear all stored tokens
  Future<void> clearTokens() async {
    if (kDebugMode) {
      print('BackgroundTokenRefreshService: Clearing tokens');
    }
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
