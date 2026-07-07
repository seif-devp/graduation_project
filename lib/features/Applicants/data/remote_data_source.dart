import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/Applicants/data/model_view_data.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class ApplicantsRemoteDataSource {
  
  Future<List<JobModelResponse>> getEmployerJobs() async {
    final response = await DioFactory.getDio().get('/api/jobs');
    
    if (response.data is Map && response.data['items'] != null) {
      final list = response.data['items'] as List;
      // بنادي على الـ factory المظبوط بتاع موديل المشروع الأصلي
      return list.map((e) => JobModelResponse.fromJson(e)).toList();
    } else if (response.data is List) {
      final list = response.data as List;
      return list.map((e) => JobModelResponse.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<ApplicationModel>> getApplicantsByJob(String jobId) async {
    final response = await DioFactory.getDio().get('/api/applications/job/$jobId');
    print(response.data);
    final items = response.data['items'] as List;

    return items
        .map((e) => ApplicationModel.fromJson(e))
        .where((applicant) {
          final s = applicant.status.toLowerCase();
          return s != 'rejected' && s != 'accepted';
        })
        .toList();
  }

  Future<void> updateStatus(String applicationId, String status) async {
    await DioFactory.getDio().patch(
      '/api/applications/$applicationId/status',
      data: {'status': status.toLowerCase()},
    );
  }
}