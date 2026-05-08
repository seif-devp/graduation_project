import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/job_details/data/model_detail.dart';


class JobDetailsRemoteDataSource {
  Future<JobDetailsModel> getJobById(String id) async {
    
    final response = await DioFactory.getDio().get('/api/jobs/$id');
    return JobDetailsModel.fromJson(response.data);
  }
}