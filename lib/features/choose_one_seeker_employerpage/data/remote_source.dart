import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/choose_one_seeker_employerpage/data/model.dart';

class ApplicantDetailsRemoteDataSource {
  Future<ApplicantDetailsModel> getApplicantDetails(
    String applicationId,
  ) async {
    final response = await DioFactory.getDio().get(
      '/api/applications/$applicationId',
    );

    return ApplicantDetailsModel.fromJson(
      response.data,
    );
  }
}
