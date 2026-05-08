import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/model_response.dart';

class HomeSeekerRemoteDataSource {
  Future<JobResponseModel> getRecommendedJobs() async {
    final response = await DioFactory.getDio().get(
      '/api/jobs',
      queryParameters: {'page': 1, 'pageSize': 20}, 
    );
    return JobResponseModel.fromJson(response.data);
  }
}