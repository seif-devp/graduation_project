import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/Home/Home_employer/data/remote_data_source_eployer.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class EmployerHomeRepository {
  final RemoteDataSourceEployer remoteDataSourceEployer;

  EmployerHomeRepository(this.remoteDataSourceEployer);

  Future<Either<Failure, List<JobModelResponse>>> getJobs() async {
    try {
      final jobs = await remoteDataSourceEployer.getJobs();
      return Right(jobs);
    } catch (e) {
      return Left(ServerFailure("فشل في جلب الوظائف"));
    }
  }

  Future<Either<Failure, void>> deleteJob(String id) async {
    try {
      await remoteDataSourceEployer.deleteJob(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ أثناء محاولة حذف الوظيفة"));
    }
  }
}