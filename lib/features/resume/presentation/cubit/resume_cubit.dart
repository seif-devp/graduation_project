import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/remote_source.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/repo.dart';
import 'package:graduation_project/features/resume/data/model.dart';
import 'package:graduation_project/features/resume/data/repo.dart';

part 'resume_state.dart';

class ResumeCubit extends Cubit<ResumeState> {
  final ResumeRepository repository;

  ResumeCubit(this.repository) : super(ResumeInitial());

  // ✅ فانكشن واحدة بس مع jobId اختياري
  Future<void> uploadResume(String filePath, {String? jobId}) async {
    emit(ResumeLoading());
    final result = await repository.uploadResume(filePath);
    result.fold(
      (failure) => emit(ResumeFailure(failure.message)),
      (resume) async {
        if (jobId != null) {
          // ✅ بعمل apply تلقائي بعد الـ upload مع إعطاء aiScore قيمة صفرية لمنع الإيرور
          final applyResult = await ApplicationRepository(
            ApplicationRemoteDataSource(),
          ).submitApplication(
            jobId: jobId,
            resumeId: resume.id,
            aiScore: 0, // 👈 دي اللي كانت ناقصة ومسببة الخط الأحمر عندك
          );
          
          applyResult.fold(
            (failure) => emit(ResumeFailure(failure.message)),
            (_) => emit(ResumeSuccess(resume)),
          );
        } else {
          emit(ResumeSuccess(resume));
        }
      },
    );
  }
}