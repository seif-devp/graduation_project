import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/settings/settingsSekeer/logic/entitiy.dart';

class SettingsSekeerRepository {
  Future<SeekerEntity> getUserData() async {
    try {
      final response = await DioFactory.getDio().get('/api/users/me');
      if (response.statusCode == 200) {
        final data = response.data;
        return SeekerEntity(
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          bio: data['bio'] ?? '',
          avatarUrl: data['avatarUrl'] ?? data['avatar'],
          isLightMode: true,
        );
      } else {
        throw Exception('Failed to load settings data');
      }
    } on DioException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }

  // ضيف الدالة دي جوه كلاس SettingsSekeerRepository
  Future<void> updateBasicProfile({
    required String name,
    required String phone,
    required String bio,
  }) async {
    try {
      final response = await DioFactory.getDio().put(
        '/api/users/me',
        data: {
          "name": name,
          "phone": phone,
          "bio": bio,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } on DioException catch (e) {
      throw Exception('Error: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> updateAvatar(String filePath) async {
    try {
      final file = File(filePath);
      final fileName = file.uri.pathSegments.last;
      final formData = FormData.fromMap({
        'File': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await DioFactory.getDio().put(
        '/api/users/me/avatar',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to upload avatar');
      }
    } on DioException catch (e) {
      throw Exception('Avatar upload failed: ${e.response?.data ?? e.message}');
    }
  }
}
