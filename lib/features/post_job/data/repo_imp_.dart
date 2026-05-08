import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/post_job/data/model_request.dart';
import 'package:graduation_project/features/post_job/data/remote_data.dart';
import 'package:graduation_project/features/post_job/logic/repo.dart';

class JobEmployerRepositoryImpl implements RepoPostJobINterface {
  final RemoteDataPostJob remoteDataPostJob;

  JobEmployerRepositoryImpl(this.remoteDataPostJob);

  @override
  Future<Either<Failure, void>> createJob(JobRequestModel jobData) async {
    try {
      await remoteDataPostJob.createJob(jobData);
      return const Right(null);
    } catch (e) {

      return Left(ServerFailure("حدث خطأ أثناء رفع الوظيفة"));
    }
  }


}
