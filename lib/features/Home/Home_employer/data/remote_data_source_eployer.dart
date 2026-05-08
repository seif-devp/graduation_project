// دالة حذف وظيفة
  import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';
class RemoteDataSourceEployer {
  
Future<void> deleteJob(String id) async {
    await DioFactory.getDio().delete(
      '/api/jobs/$id',
    );
  }

  Future<List<JobModelResponse>> getJobs({
    String? keyword,
    String? location,
    String? type,
    String? salary,
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await DioFactory.getDio().get(
      '/api/jobs',
    );

    return (response.data['items'] as List)
        .map((e) => JobModelResponse.fromJson(e))
        .toList();
  }
}