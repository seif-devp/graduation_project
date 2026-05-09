import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/response.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/model.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/remote_source.dart';


class ApplicationRepository {
  final ApplicationRemoteDataSource remoteDataSource;

  ApplicationRepository(this.remoteDataSource);

  Future<Either<Failure, ApplicationResponseModel>> submitApplication({
    required String jobId,
    required String resumeId,
  }) async {
    try {
      final result = await remoteDataSource.submitApplication(
        ApplicationRequestModel(jobId: jobId, resumeId: resumeId),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('فشل في تقديم الطلب: ${e.toString()}'));
    }
  }
}