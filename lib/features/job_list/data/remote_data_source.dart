// features/job_list/data/data_sources/jobs_remote_data_source.dart
import 'package:graduation_project/core/networking/dio.dart';

import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class JobsRemoteDataSource {
  // get => job_sekker
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

      queryParameters: {
        if (keyword != null) 'Keyword': keyword,
        if (location != null) 'Location': location,
        if (type != null) 'Type': type,
        if (salary != null) 'Salary': salary,
        'Page': page,
        'PageSize': pageSize,
      },
    );

    return (response.data['items'] as List)
        .map((e) => JobModelResponse.fromJson(e))
        .toList();
  }
  
}
