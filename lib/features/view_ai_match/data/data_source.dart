import 'package:dio/dio.dart';
class CvMatchService {
  // ✅ غير الـ IP ده بـ IP الـ PC بتاعك
  // لو على emulator: 10.0.2.2
  // لو على موبايل حقيقي: IP الـ WiFi بتاعك (ipconfig)
  static const String _baseUrl = 'http://10.0.2.2:8000';

  Future<Map<String, dynamic>> getMatchScore({
    required String cvPath,
    required String jobDescription,
  }) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));

      final formData = FormData.fromMap({
        'cv': await MultipartFile.fromFile(cvPath),
        'job_description': jobDescription,
      });

      final response = await dio.post('/match', data: formData);

      return {
        'match_score': response.data['match_score'],
        'result': response.data['result'],
      };
    } catch (e) {
      return {
        'match_score': 0,
        'result': 'Error',
      };
    }
  }
}