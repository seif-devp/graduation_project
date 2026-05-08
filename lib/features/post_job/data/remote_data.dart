import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/post_job/data/model_request.dart';

class RemoteDataPostJob {
  Future<void> createJob(JobRequestModel jobModel) async {

    await DioFactory.getDio().post(
      '/api/jobs/',
      data: jobModel.toJson(),
     
    );
  }
  
  Future<void> deleteJob(String id) async {
  await DioFactory.getDio().delete(
    '/api/jobs/$id',
  );
}
}
