import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/Applicants/data/model_view_data.dart';

class ApplicantsRemoteDataSource {
  Future<List<ApplicationModel>> getApplicantsByJob(String jobId) async {
    final response = await DioFactory.getDio().get(
      '/api/applications/job/$jobId',
    );
    final items = response.data['items'] as List;

    return items
        .map((e) => ApplicationModel.fromJson(e))
        // ✅ بنشوف كل اللي مش Rejected ومش Shortlisted
        .where((applicant) =>
            applicant.status != 'Rejected' &&
            applicant.status != 'Shortlisted')
        .toList();
  }

  Future<void> updateStatus(String applicationId, String status) async {
    await DioFactory.getDio().patch(
      '/api/applications/$applicationId/status',
      data: {'status': status},
    );
  }
}