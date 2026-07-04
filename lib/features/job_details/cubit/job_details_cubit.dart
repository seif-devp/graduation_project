import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/remote_source.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/repo.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/job_details/data/model_detail.dart';
import 'package:graduation_project/features/job_details/data/repo_imp_detail.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  final JobDetailsRepo repo;
  final ApplicationRepository applicationRepository = ApplicationRepository(
    ApplicationRemoteDataSource(),
  );

  JobDetailsModel? _currentJob;
  bool _hasApplied = false;

  double? matchScore;
  List<String> matchedSkills = [];
  List<String> missingSkills = [];

  JobDetailsModel? get currentJob => _currentJob;
  bool get hasApplied => _hasApplied;

  JobDetailsCubit(this.repo) : super(JobDetailsInitial());

  Future<void> fetchJobDetails(String id) async {
    emit(JobDetailsLoading());
    final result = await repo.getJobDetails(id);
    result.fold(
      (failure) => emit(JobDetailsError(failure.message)),
      (job) {
        _currentJob = job;
        emit(JobDetailsSuccess(job));
      },
    );
  }

  Future<void> uploadAndSubmitApplication({
    required String jobId,
    required String cvPath,
    required String jobDescription,
  }) async {
    emit(ApplyJobLoading());

    int finalAiScore = 0;

    // 1️⃣ حساب الـ AI من سيرفر البايثون
    final aiResult = await applicationRepository.getAiMatchScore(cvPath, jobDescription);
    aiResult.fold(
      (failure) {
        finalAiScore = 0; 
      },
      (data) {
        // حماية التحويل من dynamic لـ double ثم تقريبه لـ int صريح لـ .NET
        var rawScore = data['match_score'] ?? 0;
        matchScore = rawScore is num ? rawScore.toDouble() : double.tryParse(rawScore.toString()) ?? 0.0;
        
        matchedSkills = List<String>.from(data['matched_skills'] ?? []);
        missingSkills = List<String>.from(data['missing_skills'] ?? []);
        
        finalAiScore = matchScore!.round(); // ✅ السكور الفعلي الدقيق
      },
    );

    // 2️⃣ الرفع للـ .NET
    final uploadResult = await applicationRepository.uploadResumeToDotNet(cvPath);

    await uploadResult.fold(
      (failure) async {
        emit(ApplyJobError(failure.message));
      },
      (realResumeId) async {
        await CacheHelper.saveData(key: 'resumeId', value: realResumeId);

        // 3️⃣ تقديم الطلب النهائي بالسكور الصحيح تماماً ليظهر عند الأمبلوير
        final submitResult = await applicationRepository.submitApplication(
          jobId: jobId,
          resumeId: realResumeId,
          aiScore: finalAiScore, 
        );

        submitResult.fold(
          (failure) => emit(ApplyJobError(failure.message)),
          (_) {
            _hasApplied = true;
            emit(ApplyJobSuccess());
          },
        );
      },
    );

    if (_currentJob != null) emit(JobDetailsSuccess(_currentJob!));
  }
}