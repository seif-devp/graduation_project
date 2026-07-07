import 'package:graduation_project/features/interviews/interviews_seeker/domain/entity.dart';

abstract class InterviewState {}

class InterviewInitial extends InterviewState {}

class InterviewLoading extends InterviewState {}

class InterviewLoaded extends InterviewState {
  final List<InterviewEntity> interviews;
  InterviewLoaded(this.interviews);
}

class InterviewActionLoading extends InterviewState {
  final List<InterviewEntity> interviews;
  final String interviewId;
  InterviewActionLoading(this.interviews, this.interviewId);
}

class InterviewError extends InterviewState {
  final String message;
  InterviewError(this.message);
}

class InterviewEmpty extends InterviewState {}
