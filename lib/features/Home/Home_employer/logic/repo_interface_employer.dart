import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/Home/Home_employer/data/remote_data_source_eployer.dart';
import 'package:graduation_project/features/Home/Home_employer/logic/entity.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class EmployerHomeRepository {
  final RemoteDataSourceEployer remoteDataSourceEployer;

  EmployerHomeRepository(this.remoteDataSourceEployer);

  Future<Either<Failure, EmployerHomeEntity>> getHomeData() async {
    try {

      return  Right(EmployerHomeEntity(
        activeJobs: 0,
        newApplicants: 0,
        interviewsToday: 0,
        interviewsCount: 0,
        applicantsCount: 0,
      ));
    } catch (e) {
      return Left(ServerFailure("فشل في تحميل بيانات الصفحة الرئيسية"));
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


  Future<Either<Failure, List<JobModelResponse>>> getAllJobs() async {
    try {
      final jobs = await remoteDataSourceEployer.getJobs();
      return Right(jobs);
    } catch (e) {
      return Left(ServerFailure("فشل في جلب قائمة الوظائف الخاصة بك"));
    }
  }
}