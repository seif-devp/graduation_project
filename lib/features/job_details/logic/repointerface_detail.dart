import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/job_details/data/model_detail.dart';

 abstract class RepointerfaceDetail {
  Future<Either<Failure, JobDetailsModel>> getJobDetails(String id);
}
