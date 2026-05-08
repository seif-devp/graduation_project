import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/Home/Home_employer/data/remote_data_source_eployer.dart';
import 'package:graduation_project/features/Home/Home_employer/logic/entity.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class EmployerHomeRepository {
  final RemoteDataSourceEployer remoteDataSourceEployer;
  EmployerHomeRepository(this.remoteDataSourceEployer);

  Future<EmployerHomeEntity> getHomeData() async {
    // تم إضافة الـ Body بشكل صحيح لحل خطأ Syntax
    return EmployerHomeEntity(
      activeJobs: 0,
      newApplicants: 0,
      interviewsToday: 0,
      interviewsCount: 0,
      applicantsCount: 0,
    );
  }

  Future<Either<Failure, void>> deleteJob(String id) async {
    try {
      await remoteDataSourceEployer.deleteJob(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("فشل حذف الوظيفة"));
    }
  }

  Future<Either<Failure, List<JobModelResponse>>> getJobs() async {
    try {
      final result = await remoteDataSourceEployer.getJobs();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure("فشل تحميل الوظائف"));
    }
  }
}