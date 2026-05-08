import 'package:dio/dio.dart';

class DioFactory {
  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      dio = Dio(BaseOptions(
        baseUrl: "https://smartjop.runasp.net",
        receiveTimeout: const Duration(seconds: 120),
        connectTimeout: const Duration(seconds: 120),
      ));

      dio!.interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true));
    }
    return dio!;
  }
}
