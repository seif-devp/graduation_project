import 'package:dio/dio.dart';

class DioFactory {
  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      dio = Dio(BaseOptions(
        baseUrl: "https://smartjop.runasp.net",
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ));

      dio!.interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true));
    }
    return dio!;
  }
}
