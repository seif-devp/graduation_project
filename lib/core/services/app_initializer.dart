import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/features/Auth/data/services/background_token_refresh_service.dart';

/// Global app initializer - handles all app startup tasks
class AppInitializer {
  static final AppInitializer _instance = AppInitializer._internal();

  factory AppInitializer() {
    return _instance;
  }

  AppInitializer._internal();

  /// Initialize all services at app startup
  Future<void> initialize() async {
    try {
      await CacheHelper.init();
      await _initializeBackgroundTokenRefresh();
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize background token refresh service if user is authenticated
  Future<void> _initializeBackgroundTokenRefresh() async {
    try {
      final accessToken = CacheHelper.getData(key: 'accessToken');
      final refreshToken = CacheHelper.getData(key: 'refreshToken');

      // If user has both tokens, start the background refresh service
      if (_isValidToken(accessToken) && _isValidToken(refreshToken)) {
        BackgroundTokenRefreshService().startBackgroundRefresh(
          checkIntervalMinutes: 5,
        );
      }
    } catch (e) {
      // Allow app to continue if background refresh cannot start.
    }
  }

  /// Check if token is valid (not null, not empty)
  bool _isValidToken(dynamic token) {
    return token != null && (token is String) && token.isNotEmpty;
  }

  /// Restart background token refresh (useful after app resume)
  void restartBackgroundRefresh() {
    try {
      final accessToken = CacheHelper.getData(key: 'accessToken');
      final refreshToken = CacheHelper.getData(key: 'refreshToken');

      if (_isValidToken(accessToken) && _isValidToken(refreshToken)) {
        BackgroundTokenRefreshService().startBackgroundRefresh(
          checkIntervalMinutes: 5,
        );
      }
    } catch (e) {
      // Ignore restart failures silently.
    }
  }

  /// Cleanup - called when app is closing or user logs out
  Future<void> cleanup() async {
    try {
      BackgroundTokenRefreshService().stopBackgroundRefresh();
    } catch (e) {
      // Ignore cleanup failures.
    }
  }
}
