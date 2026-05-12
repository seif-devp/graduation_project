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
}