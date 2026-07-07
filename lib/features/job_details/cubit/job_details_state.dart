import 'package:graduation_project/features/job_details/data/model_detail.dart';
import 'package:graduation_project/features/job_details/data/ai_match_model.dart';

sealed class JobDetailsState {}

final class JobDetailsInitial extends JobDetailsState {}
final class JobDetailsLoading extends JobDetailsState {}

final class JobDetailsSuccess extends JobDetailsState {
  final JobDetailsModel job;
  JobDetailsSuccess(this.job);
}

final class JobDetailsError extends JobDetailsState {
  final String message;
  JobDetailsError(this.message);
}

// حالات التقديم والـ AI
final class ApplyJobLoading extends JobDetailsState {}

final class ApplyJobSuccess extends JobDetailsState {
  final AiMatchModel aiResult;
  ApplyJobSuccess(this.aiResult);
}

final class ApplyJobError extends JobDetailsState {
  final String message;
  ApplyJobError(this.message);
}