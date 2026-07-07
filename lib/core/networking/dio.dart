import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/error_interceptor.dart';
import 'package:graduation_project/features/Auth/data/services/token_refresh_interceptor.dart';

class DioFactory {
  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      dio = Dio(BaseOptions(
        baseUrl: "https://smartjop.runasp.net",
        receiveTimeout: const Duration(seconds: 60),
        connectTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));
      dio!.interceptors.add(ErrorInterceptor());
      dio!.interceptors.add(TokenRefreshInterceptor(dioClient: dio!));
      dio!.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
    return dio!;
  }

  static void resetDio() {
    dio = null;
  }
}