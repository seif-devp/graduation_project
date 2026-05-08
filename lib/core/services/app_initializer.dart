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
      // Initialize cache helper first
      await CacheHelper.init();
      print('✓ Cache helper initialized');

      // Initialize background token refresh if user is authenticated
      await _initializeBackgroundTokenRefresh();
    } catch (e) {
      print('❌ Error during app initialization: $e');
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
        print('✓ Background token refresh service started');
      } else {
        print('ℹ️ No valid tokens found - Background refresh not started');
      }
    } catch (e) {
      print('⚠️ Error initializing background token refresh: $e');
      // Don't rethrow - allow app to continue even if refresh service fails to start
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
        print('✓ Background token refresh restarted');
      }
    } catch (e) {
      print('❌ Error restarting background token refresh: $e');
    }
  }

  /// Cleanup - called when app is closing or user logs out
  Future<void> cleanup() async {
    try {
      BackgroundTokenRefreshService().stopBackgroundRefresh();
      print('✓ Background token refresh stopped');
    } catch (e) {
      print('❌ Error during cleanup: $e');
    }
  }
}
