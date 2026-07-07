import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/repo.dart'; // الـ import الصح
import 'ai_match_model.dart';
import 'ai_remote_source.dart';

class JobApplicationRepository {
  final AiMatchRemoteDataSource aiRemoteSource;
  final ApplicationRepository dotNetRepo; // التعديل هنا

  JobApplicationRepository({
    required this.aiRemoteSource,
    required this.dotNetRepo, // التعديل هنا
  });

  Future<Either<Failure, AiMatchModel>> processAndApply({
    required String jobId,
    required String resumeId,
    required String cvUrl,
    required String jobDescription,
  }) async {
    try {
      // 1. تنزيل الـ CV من الرابط لملف مؤقت عشان الـ AI يحلله
      final tempDir = await getTemporaryDirectory();
      final localCvPath = '${tempDir.path}/temp_cv_$resumeId.pdf';

      // ✅ التعديل هنا: تكملة الرابط لو راجع ناقص من الباك إند
      String fullUrl = cvUrl;
      if (!fullUrl.startsWith('http')) {
        // ⚠️ استبدل الرابط ده بالـ Base URL الحقيقي بتاع سيرفر الـ .NET بتاعك (نفس اللي في DioFactory)
        const baseUrl = 'https://smartjop.runasp.net';
        fullUrl = '$baseUrl$cvUrl';
      }

      await Dio().download(fullUrl, localCvPath);

      // 2. إرسال الملف لـ AI
      final aiResult = await aiRemoteSource.getMatchScore(
        cvPath: localCvPath,
        jobDescription: jobDescription,
      );

      // 3. تقديم الطلب لـ .NET
      final applyResult = await dotNetRepo.submitApplication(
        jobId: jobId,
        resumeId: resumeId,
        aiScore: aiResult.matchScore.round(),
      );

      // 4. مسح الملف المؤقت
      final file = File(localCvPath);
      if (await file.exists()) {
        await file.delete();
      }

      // لو التقديم نجح نرجع داتا الـ AI، لو فشل نرجع الخطأ
      return applyResult.fold(
        (failure) => Left(failure),
        (_) => Right(aiResult),
      );
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء معالجة الطلب: ${e.toString()}'));
    }
  }
}
