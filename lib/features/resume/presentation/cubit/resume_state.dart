part of 'resume_cubit.dart';

sealed class ResumeState {}

final class ResumeInitial extends ResumeState {}

// 📌 الحالات القديمة (خاصة بشاشة الـ Upload & Apply)
final class ResumeLoading extends ResumeState {}
final class ResumeSuccess extends ResumeState {
  final ResumeModel resume;
  ResumeSuccess(this.resume);
}
final class ResumeFailure extends ResumeState {
  final String errorMessage;
  ResumeFailure(this.errorMessage);
}

// 📌 الحالات الجديدة (خاصة بشاشة الـ Profile)
// جلب البيانات
final class GetResumesLoading extends ResumeState {}
final class GetResumesSuccess extends ResumeState {
  final List<ResumeModel> resumes;
  GetResumesSuccess(this.resumes);
}
final class GetResumesFailure extends ResumeState {
  final String errorMessage;
  GetResumesFailure(this.errorMessage);
}

// العمليات (مسح، تعيين كافتراضي، ورفع من البروفايل)
final class ResumeActionLoading extends ResumeState {}
final class ResumeActionSuccess extends ResumeState {
  final String message;
  ResumeActionSuccess(this.message);
}