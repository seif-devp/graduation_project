import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import '../models/profile_model.dart';

class ProfileServices {
  final Dio dio = DioFactory.getDio();

  Future<ProfileModel> getUserProfile() async {
    try {
      final response = await dio.get('/api/users/me');
      
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Error: $errorMsg');
    }
  }
}