part of 'resume_cubit.dart';

sealed class ResumeState {}

final class ResumeInitial extends ResumeState {}
final class ResumeLoading extends ResumeState {}
final class ResumeSuccess extends ResumeState {
  final ResumeModel resume;
  ResumeSuccess(this.resume);
}
final class ResumeFailure extends ResumeState {
  final String errorMessage;
  ResumeFailure(this.errorMessage);
}