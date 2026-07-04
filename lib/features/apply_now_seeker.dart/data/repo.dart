import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/model.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/remote_source.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/response.dart';

class ApplicationRepository {
  final ApplicationRemoteDataSource remoteDataSource;

  ApplicationRepository(this.remoteDataSource);

  Future<Either<Failure, ApplicationResponseModel>> submitApplication({
    required String jobId,
    required String resumeId,
    int aiScore = 0, // ✅ اختياري لمنع إيرور الـ ResumeCubit القديم
  }) async {
    try {
      final result = await remoteDataSource.submitApplication(
        ApplicationRequestModel(
          jobId: jobId, 
          resumeId: resumeId, 
          aiMatchScore: aiScore,
        ),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('فشل في تقديم الطلب: ${e.toString()}'));
    }
  }

  Future<Either<Failure, String>> uploadResumeToDotNet(String filePath) async {
    try {
      final resumeId = await remoteDataSource.uploadResume(filePath);
      return Right(resumeId);
    } catch (e) {
      return Left(ServerFailure('فشل في رفع السيرة الذاتية للـ .NET: ${e.toString()}'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getAiMatchScore(
      String cvPath, String jobDescription) async {
    try {
      final result = await remoteDataSource.calculateAiMatch(
          cvPath: cvPath, jobDescription: jobDescription);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('فشل في حساب مطابقة الذكاء الاصطناعي: ${e.toString()}'));
    }
  }
}