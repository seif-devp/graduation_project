import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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

  // ✅ جلب السير الذاتية
  Future<Either<Failure, List<ResumeModel>>> getResumes() async {
    try {
      final result = await remoteDataSource.getResumes();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('فشل في جلب السيرة الذاتية: ${e.toString()}'));
    }
  }

  // ✅ حذف سيرة ذاتية
  Future<Either<Failure, void>> deleteResume(String id) async {
    try {
      await remoteDataSource.deleteResume(id);
      return const Right(null);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 500) {
        return Left(ServerFailure('Server error during delete, please try again later.'));
      }
      return Left(ServerFailure('Failed to delete resume: ${e.toString()}'));
    }
  }

  // ✅ تعيين سيرة ذاتية كأساسية
  Future<Either<Failure, void>> setDefaultResume(String id) async {
    try {
      await remoteDataSource.setDefaultResume(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('فشل في تعيين السيرة الذاتية كأساسية: ${e.toString()}'));
    }
  }
}