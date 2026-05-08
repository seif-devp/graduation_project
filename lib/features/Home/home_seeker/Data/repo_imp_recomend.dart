import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/model_response.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/remote_source_recomendion.dart';
import 'package:graduation_project/features/Home/home_seeker/logic/repo_interface_recomend.dart';


class HomeSeekerRepoImpl implements HomeSeekerRepo {
  final HomeSeekerRemoteDataSource remoteDataSource;
  HomeSeekerRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<JobModel>>> getJobsRecomend() async {
    try {
      final response = await remoteDataSource.getRecommendedJobs();
      return Right(response.items);
    } catch (e) {
      return Left(ServerFailure("فشل في تحميل الوظائف"));
    }
  }
  

}