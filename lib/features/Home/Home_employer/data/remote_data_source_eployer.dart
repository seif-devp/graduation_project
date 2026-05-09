import 'dart:convert';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class RemoteDataSourceEployer {
  Future<void> deleteJob(String id) async {
    await DioFactory.getDio().delete('/api/jobs/$id');
  }

  Future<List<JobModelResponse>> getJobs() async {
    final response = await DioFactory.getDio().get('/api/jobs');

    // ✅ بنجيب الـ currentEmployerId من الـ JWT token
    String? currentEmployerId;
    try {
      final token = CacheHelper.getData(key: 'accessToken') as String?;
      if (token != null) {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final normalized = base64Url.normalize(payload);
          final decoded = utf8.decode(base64Url.decode(normalized));
          final Map<String, dynamic> data = json.decode(decoded);
          currentEmployerId = data['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
        }
      }
    } catch (e) {
      print('Error decoding token: $e');
    }

    final allJobs = (response.data['items'] as List)
        .map((e) => JobModelResponse.fromJson(e))
        .toList();

    // ✅ فلترة الوظايف بتاعت الـ employer ده بس
    if (currentEmployerId != null) {
      return allJobs
          .where((job) => job.employerId == currentEmployerId)
          .toList();
    }

    return allJobs;
  }
}