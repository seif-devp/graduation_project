import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/model_response.dart';

abstract class HomeSeekerRepo {
  Future<Either<Failure, List<JobModel>>> getJobsRecomend();
}

