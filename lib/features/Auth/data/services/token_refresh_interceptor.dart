import 'package:dio/dio.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';

class TokenRefreshInterceptor extends Interceptor {
  final Dio dioClient;
  bool _isRefreshing = false;

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
    // If status code is 401, attempt to refresh token
    if (err.response?.statusCode == 401) {
      if (_isRefreshing) {
        // Wait for token refresh to complete
        try {
          final newToken = await Future.delayed(
            const Duration(seconds: 1),
            () => CacheHelper.getData(key: 'accessToken'),
          );

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
          return handler.reject(err);
        }
        return handler.reject(err);
      }

      _isRefreshing = true;

      try {
        final refreshToken = CacheHelper.getData(key: 'refreshToken');

        if (refreshToken == null || refreshToken.isEmpty) {
          // No refresh token available, propagate the error
          _isRefreshing = false;
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

        _isRefreshing = false;

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
        _isRefreshing = false;
        return handler.reject(e);
      } catch (e) {
        _isRefreshing = false;
        return handler.reject(err);
      }
    }

    handler.next(err);
  }

  /// Make refresh token request
  Future<Map<String, dynamic>> _refreshTokenRequest(
    String refreshToken,
  ) async {
    try {
      final response = await dioClient.post(
        '/api/auth/refresh-token',
        data: {'refreshToken': refreshToken},
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'accessToken': response.data['accessToken'],
          'refreshToken': response.data['refreshToken'],
          'expiresAtUtc': response.data['expiresAtUtc'],
        };
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/api/auth/refresh-token'),
          message: 'Failed to refresh token',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
