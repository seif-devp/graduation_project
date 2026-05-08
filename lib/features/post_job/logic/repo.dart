import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/post_job/data/model_request.dart';

abstract class RepoPostJobINterface {
    Future<Either<Failure, void>> createJob(JobRequestModel jobData);
}