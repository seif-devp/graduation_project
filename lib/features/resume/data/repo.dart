import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/resume/data/model.dart';
import 'package:graduation_project/features/resume/data/remote.dart';

class ResumeRepository {
  final ResumeRemoteDataSource remoteDataSource;

  ResumeRepository(this.remoteDataSource);

  Future<Either<Failure, ResumeModel>> uploadResume(String filePath) async {
    try {
      final result = await remoteDataSource.uploadResume(filePath);
  
      await CacheHelper.saveData(key: 'resumeId', value: result.id);
      
      await CacheHelper.saveData(key: 'cvPath', value: filePath);
      
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Error Upload Cv: ${e.toString()}'));
    }
  }
}