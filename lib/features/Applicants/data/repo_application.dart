import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/Applicants/data/model_view_data.dart';
import 'package:graduation_project/features/Applicants/data/remote_data_source.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class ApplicantsRepository {
  final ApplicantsRemoteDataSource remoteDataSource;

  ApplicantsRepository(this.remoteDataSource);

  Future<Either<Failure, List<JobModelResponse>>> getEmployerJobs() async {
    try {
      final result = await remoteDataSource.getEmployerJobs();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to load jobs: ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<ApplicationModel>>> getApplicants(String jobId) async {
    try {
      final result = await remoteDataSource.getApplicantsByJob(jobId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to load applicants: ${e.toString()}'));
    }
  }

  Future<Either<Failure, void>> updateStatus(String applicationId, String status) async {
    try {
      await remoteDataSource.updateStatus(applicationId, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update status: ${e.toString()}'));
    }
  }
}