import 'package:dio/dio.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/features/Auth/data/models/response.dart';
import 'package:graduation_project/features/Auth/data/services/token_refresh_interceptor.dart';

class AuthServices {
  final String url = 'https://smartjop.runasp.net';
  late final Dio dio;

  AuthServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    // Add token refresh interceptor
    dio.interceptors.add(TokenRefreshInterceptor(dioClient: dio));
  }

  /// Register a job seeker with all their information
  Future<AuthResponseModel> registerJobSeeker({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int experienceYears,
    required int educationLevel,
    required List<String> skills,
    required String linkedInUrl,
    required String gitHubUrl,
  }) async {
    final data = {
      'email': email,
      'password': password,
      'name': name,
      'role': 0,
      'phone': phone,
      'experienceYears': experienceYears,
      'educationLevel': educationLevel,
      'skills': skills,
      'linkedInUrl': linkedInUrl,
      'gitHubUrl': gitHubUrl,
    };

    try {
      final response = await dio.post('/api/auth/register', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        await CacheHelper.saveData(
            key: 'accessToken', value: authResponse.accessToken);
        await CacheHelper.saveData(
            key: 'refreshToken', value: authResponse.refreshToken);
        await CacheHelper.saveData(
            key: 'expiresAtUtc', value: authResponse.expiresAtUtc);

        return authResponse;
      } else {
        throw Exception(
            'Failed to register job seeker: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Failed to register job seeker: $errorMsg');
    }
  }

  Future<AuthResponseModel> registerEmployer({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String companyName,
    required int companySize,
    required String industry,
    required String website,
  }) async {
    final data = {
      'email': email,
      'password': password,
      'name': name,
      'role': 1,
      'phone': phone,
      'companyName': companyName,
      'companySize': companySize,
      'industry': industry,
      'website': website,
    };

    try {
      final response = await dio.post('/api/auth/register', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        await CacheHelper.saveData(
            key: 'accessToken', value: authResponse.accessToken);
        await CacheHelper.saveData(
            key: 'refreshToken', value: authResponse.refreshToken);
        await CacheHelper.saveData(
            key: 'expiresAtUtc', value: authResponse.expiresAtUtc);

        return authResponse;
      } else {
        throw Exception(
            'Failed to register employer: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Failed to register employer: $errorMsg');
    }
  }

  /// General login method
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await dio.post('/api/auth/login', data: data);

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        await CacheHelper.saveData(
            key: 'accessToken', value: authResponse.accessToken);
        await CacheHelper.saveData(
            key: 'refreshToken', value: authResponse.refreshToken);
        await CacheHelper.saveData(
            key: 'expiresAtUtc', value: authResponse.expiresAtUtc);

        return authResponse;
      } else {
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Failed to login: $errorMsg');
    }
  }
}
