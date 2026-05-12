import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/settings/setting_employer/logic/entitiy.dart';

class SettingsRepository {
  Future<UserEntity> getUserData() async {
    try {
      final response = await DioFactory.getDio().get('/api/users/me');

      if (response.statusCode == 200) {
        final data = response.data;
        final employerData = data['employerProfile'] as Map<String, dynamic>?;

        return UserEntity(
          // ضفنا ?.toString() لكل الحقول عشان نحمي الكود من أي أرقام مفاجئة
          name: data['name']?.toString() ?? '',
          email: data['email']?.toString() ?? '',
          phone: data['phone']?.toString() ?? '',
          bio: data['bio']?.toString() ?? '',
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
}
