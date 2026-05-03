import 'package:graduation_project/features/interviews/domain/entity.dart';

abstract class InterviewState {}

class InterviewInitial extends InterviewState {}

class InterviewLoading extends InterviewState {}

class InterviewLoaded extends InterviewState {
  final List<InterviewEntity> interviews;
  InterviewLoaded(this.interviews);
}

class InterviewError extends InterviewState {
  final String message;
  InterviewError(this.message);
}

class InterviewEmpty extends InterviewState {}
