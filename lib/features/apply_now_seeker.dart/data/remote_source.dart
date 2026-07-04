import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/model.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/response.dart';

class ApplicationRemoteDataSource {
  // 1. التقديم للـ .NET
  Future<ApplicationResponseModel> submitApplication(ApplicationRequestModel request) async {
    final response = await DioFactory.getDio().post(
      '/api/applications',
      data: request.toJson(),
    );
    return ApplicationResponseModel.fromJson(response.data);
  }

  // 2. الرفع للـ .NET
  Future<String> uploadResume(String filePath) async {
    final formData = FormData.fromMap({
      'File': await MultipartFile.fromFile(filePath, filename: 'resume.pdf'),
    });
    final response = await DioFactory.getDio().post(
      '/api/resumes', 
      data: formData,
    );
    return response.data['id'] ?? response.data['resumeId'] ?? response.data.toString();
  }

  // 3. الاتصال بسيرفر البايثون الخاص بالـ AI
  Future<Map<String, dynamic>> calculateAiMatch({
    required String cvPath,
    required String jobDescription,
  }) async {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 90),
    ));
    final formData = FormData.fromMap({
      'cv': await MultipartFile.fromFile(cvPath, filename: 'resume.pdf'),
      'job_description': jobDescription,
    });
    final response = await dio.post('http://10.0.2.2:8000/match', data: formData);
    return response.data ?? {};
  }
}