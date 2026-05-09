import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/response.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/model.dart';


class ApplicationRemoteDataSource {
  Future<ApplicationResponseModel> submitApplication(
      ApplicationRequestModel request) async {
    final response = await DioFactory.getDio().post(
      '/api/applications',
      data: request.toJson(),
    );
    return ApplicationResponseModel.fromJson(response.data);
  }
}