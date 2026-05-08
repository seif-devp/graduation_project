import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/job_details/data/model_detail.dart';
import 'package:graduation_project/features/job_details/data/remote_detail_source.dart';
import 'package:graduation_project/features/job_details/logic/repointerface_detail.dart';

class JobDetailsRepo extends RepointerfaceDetail {
  final JobDetailsRemoteDataSource remoteDataSource;
  JobDetailsRepo(this.remoteDataSource);

  @override
  Future<Either<Failure, JobDetailsModel>> getJobDetails(String id) async {
    try {
      final response = await remoteDataSource.getJobById(id);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure("تعذر تحميل تفاصيل الوظيفة"));
    }
  }
}