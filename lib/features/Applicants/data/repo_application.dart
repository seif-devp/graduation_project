import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';
import 'package:graduation_project/features/job_list/data/remote_data_source.dart';
import 'package:graduation_project/features/job_list/domain/repo_interface.dart';

class JobSeekerRepositoryImpl implements JobRepository {
  final JobsRemoteDataSource remoteDataSource;

  JobSeekerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<JobModelResponse>>> getJobs({
    String? keyword,
    String? location,
    String? type,
    String? salary,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final result = await remoteDataSource.getJobs(
        keyword: keyword,
        location: location,
        type: type,
        salary: salary,
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure("فشل تحميل الوظائف، حاول مرة أخرى"));
    }
  }

}