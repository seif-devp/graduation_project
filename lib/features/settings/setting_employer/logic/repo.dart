import 'dart:io';
import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/settings/setting_employer/data/entitiy.dart';

class SettingsRepository {
  Future<UserEntity> getUserData() async {
    try {
      final response = await DioFactory.getDio().get('/api/users/me');

      if (response.statusCode == 200) {
        final data = response.data;
        final employerData = data['employerProfile'] as Map<String, dynamic>?;

        // 🔴 التعديل هنا: الكود هيدور على الصورة في الـ avatarUrl، ولو ملقاهاش هيدور في الـ companyLogoUrl
        String? rawAvatar =
            data['avatarUrl'] ?? employerData?['companyLogoUrl'];
        String? fullAvatarUrl;

        if (rawAvatar != null && rawAvatar.isNotEmpty) {
          if (rawAvatar.startsWith('http')) {
            fullAvatarUrl = rawAvatar;
          } else {
            fullAvatarUrl = 'https://smartjop.runasp.net$rawAvatar';
          }
        }

        return UserEntity(
          name: data['name']?.toString() ?? '',
          email: data['email']?.toString() ?? '',
          phone: data['phone']?.toString() ?? '',
          bio: data['bio']?.toString() ?? '',
          avatarUrl: fullAvatarUrl,
          isLightMode: true,
          companyName: employerData?['companyName']?.toString(),
          companySize: employerData?['companySize']?.toString(),
          industry: employerData?['industry']?.toString(),
          website: employerData?['website']?.toString(),
        );
      } else {
        throw Exception('Failed to load employer data');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Parsing Error: $e');
    }
  }

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

  Future<void> updateEmployerProfile({
    required String companyName,
    required String companySize,
    required String industry,
    required String website,
  }) async {
    try {
      final response = await DioFactory.getDio().put(
        '/api/users/me/employer-profile',
        data: {
          "companyName": companyName,
          "companySize": companySize,
          "industry": industry,
          "website": website
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update company profile');
      }
    } on DioException catch (e) {
      throw Exception('Error: ${e.response?.data ?? e.message}');
    }
  }

  // 🔴 دالة رفع الصورة
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
