import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/Status%20Update%20Feature%20Employer/data/model.dart';
import 'package:graduation_project/features/Status%20Update%20Feature%20Employer/data/remote_source..dart';

class ApplicantsRepository {
  final ApplicantsRemoteDataSource remoteDataSource;

  ApplicantsRepository(this.remoteDataSource);

  Future<Either<Failure, List<ApplicantResponseModel>>> getApplicants(
      String jobId) async {
    try {
      final result = await remoteDataSource.getApplicantsByJob(jobId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to load applicants: ${e.toString()}'));
    }
  }

  Future<Either<Failure, void>> updateStatus(
      String applicationId, String status) async {
    try {
      await remoteDataSource.updateStatus(applicationId, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update status: ${e.toString()}'));
    }
  }
}