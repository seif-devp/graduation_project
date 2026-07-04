import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/remote_source.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/repo.dart';
import 'package:graduation_project/features/resume/data/model.dart';
import 'package:graduation_project/features/resume/data/repo.dart';

part 'resume_state.dart';

class ResumeCubit extends Cubit<ResumeState> {
  final ResumeRepository repository;

  ResumeCubit(this.repository) : super(ResumeInitial());

  // ✅ جلب السير الذاتية (للبروفايل)
  Future<void> getResumes() async {
    emit(GetResumesLoading());
    final result = await repository.getResumes();
    result.fold(
      (failure) => emit(GetResumesFailure(failure.message)),
      (resumes) => emit(GetResumesSuccess(resumes)),
    );
  }

  // ✅ رفع سيرة ذاتية (بتشتغل في الـ Apply وفي الـ Profile)
  Future<void> uploadResume(String filePath, {String? jobId, bool isFromProfile = false}) async {
    emit(isFromProfile ? ResumeActionLoading() : ResumeLoading());
    
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
          // لو الرفع جاي من شاشة البروفايل، نحدث القائمة
          if (isFromProfile) {
            emit(ResumeActionSuccess("تم رفع السيرة الذاتية بنجاح"));
            getResumes(); // تحديث تلقائي
          } else {
            emit(ResumeSuccess(resume)); // دي عشان الشاشة القديمة
          }
        }
      },
    );
  }

  // ✅ حذف سيرة ذاتية
  Future<void> deleteResume(String id) async {
    emit(ResumeActionLoading());
    final result = await repository.deleteResume(id);
    result.fold(
      (failure) => emit(ResumeFailure(failure.message)),
      (_) {
        emit(ResumeActionSuccess("تم حذف السيرة الذاتية بنجاح"));
        getResumes(); // تحديث القائمة بعد الحذف
      },
    );
  }

  // ✅ تعيين سيرة ذاتية كافتراضية
  Future<void> setDefaultResume(String id) async {
    emit(ResumeActionLoading());
    final result = await repository.setDefaultResume(id);
    result.fold(
      (failure) => emit(ResumeFailure(failure.message)),
      (_) {
        emit(ResumeActionSuccess("تم تعيين السيرة الذاتية كافتراضية"));
        getResumes(); // تحديث القائمة
      },
    );
  }
}