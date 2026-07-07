import 'package:dio/dio.dart';
import 'ai_match_model.dart';

class AiMatchRemoteDataSource {
  static const String _baseUrl = 'https://ai-match-8d6z.onrender.com';

  Future<AiMatchModel> getMatchScore({
    required String cvPath,
    required String jobDescription,
  }) async {
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    ));

    final formData = FormData.fromMap({
      'cv': await MultipartFile.fromFile(cvPath),
      'job_description': jobDescription,
    });

    final response = await dio.post('/match', data: formData);

    return AiMatchModel.fromJson(response.data);
  }
}