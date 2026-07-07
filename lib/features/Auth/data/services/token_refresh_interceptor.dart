import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';

class TokenRefreshInterceptor extends Interceptor {
  final Dio dioClient;
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  TokenRefreshInterceptor({required this.dioClient});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = CacheHelper.getData(key: 'accessToken');
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print('TokenRefreshInterceptor: Intercepted error');
    }
    // If status code is 401, attempt to refresh token
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        print('TokenRefreshInterceptor: 401 error detected');
      }
      if (_isRefreshing) {
        if (kDebugMode) {
          print('TokenRefreshInterceptor: Token refresh in progress, waiting...');
        }
        // Wait for token refresh to complete
        try {
          await _refreshCompleter?.future;
          if (kDebugMode) {
            print('TokenRefreshInterceptor: Token refresh completed, retrying request');
          }
          final newToken = CacheHelper.getData(key: 'accessToken');
          if (newToken != null) {
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            return handler.resolve(await dioClient.request(
              err.requestOptions.path,
              options: Options(
                method: err.requestOptions.method,
                headers: err.requestOptions.headers,
              ),
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
            ));
          }
        } catch (e) {
          if (kDebugMode) {
            print('TokenRefreshInterceptor: Error while waiting for token refresh: $e');
          }
          return handler.reject(err);
        }
        return handler.reject(err);
      }

      _isRefreshing = true;
      _refreshCompleter = Completer<void>();
      if (kDebugMode) {
        print('TokenRefreshInterceptor: Initiating token refresh');
      }

      try {
        final refreshToken = CacheHelper.getData(key: 'refreshToken');

        if (refreshToken == null || refreshToken.isEmpty) {
          if (kDebugMode) {
            print('TokenRefreshInterceptor: No refresh token found');
          }
          _isRefreshing = false;
          _refreshCompleter?.complete();
          await CacheHelper.removeData(key: 'accessToken');
          await CacheHelper.removeData(key: 'refreshToken');
          await CacheHelper.removeData(key: 'expiresAtUtc');
          return handler.reject(err);
        }

        // Attempt to refresh token
        final newTokens = await _refreshTokenRequest(refreshToken);

        // Save new tokens
        await CacheHelper.saveData(
          key: 'accessToken',
          value: newTokens['accessToken'],
        );
        await CacheHelper.saveData(
          key: 'refreshToken',
          value: newTokens['refreshToken'],
        );
        await CacheHelper.saveData(
          key: 'expiresAtUtc',
          value: newTokens['expiresAtUtc'],
        );

        if (kDebugMode) {
          print('TokenRefreshInterceptor: Token refresh successful');
        }
        _isRefreshing = false;
        _refreshCompleter?.complete();

        // Retry the original request
        err.requestOptions.headers['Authorization'] =
            'Bearer ${newTokens['accessToken']}';

        return handler.resolve(await dioClient.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        ));
      } on DioException catch (e) {
        if (kDebugMode) {
          print('TokenRefreshInterceptor: Token refresh failed: $e');
        }
        _isRefreshing = false;
        _refreshCompleter?.completeError(e);
        await CacheHelper.removeData(key: 'accessToken');
        await CacheHelper.removeData(key: 'refreshToken');
        await CacheHelper.removeData(key: 'expiresAtUtc');
        return handler.reject(e);
      } catch (e) {
        if (kDebugMode) {
          print('TokenRefreshInterceptor: Token refresh failed with unexpected error: $e');
        }
        _isRefreshing = false;
        _refreshCompleter?.completeError(e);
        await CacheHelper.removeData(key: 'accessToken');
        await CacheHelper.removeData(key: 'refreshToken');
        await CacheHelper.removeData(key: 'expiresAtUtc');
        return handler.reject(err);
      }
    }

    handler.next(err);
  }

  /// Make refresh token request
  Future<Map<String, dynamic>> _refreshTokenRequest(
    String refreshToken,
  ) async {
    if (kDebugMode) {
      print('TokenRefreshInterceptor: Making refresh token request');
    }
    try {
      final response = await dioClient.post(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('TokenRefreshInterceptor: Refresh token request successful');
        }
        return {
          'accessToken': response.data['accessToken'],
          'refreshToken': response.data['refreshToken'],
          'expiresAtUtc': response.data['expiresAtUtc'],
        };
      } else {
        if (kDebugMode) {
          print('TokenRefreshInterceptor: Refresh token request failed with status code ${response.statusCode}');
        }
        throw DioException(
          requestOptions: RequestOptions(path: '/api/auth/refresh'),
          message: 'Failed to refresh token',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('TokenRefreshInterceptor: Refresh token request failed with error: $e');
      }
      rethrow;
    }
  }
}
