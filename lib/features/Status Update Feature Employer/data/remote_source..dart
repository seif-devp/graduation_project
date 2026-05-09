import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/Status%20Update%20Feature%20Employer/data/model.dart';

class ApplicantsRemoteDataSource {
  Future<List<ApplicantResponseModel>> getApplicantsByJob(String jobId) async {
    final response = await DioFactory.getDio().get(
      '/api/applications/job/$jobId',
    );
    final items = response.data['items'] as List;
    return items.map((e) => ApplicantResponseModel.fromJson(e)).toList();
  }

  Future<void> updateStatus(String applicationId, String status) async {
    await DioFactory.getDio().patch(
      '/api/applications/$applicationId/status',
      data: {'status': status},
    );
  }
}