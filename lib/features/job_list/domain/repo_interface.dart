import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';
abstract class JobRepository {

  Future<Either<Failure, List<JobModelResponse>>> getJobs({
    String? keyword,
    String? location,
    String? type,
    String? salary,
    int page = 1,
    int pageSize = 10,
  });

}