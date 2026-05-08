import 'package:graduation_project/features/Home/home_seeker/Data/model_response.dart';

abstract class JobState {}
class JobInitial extends JobState {}
class JobLoading extends JobState {}
class JobLoaded extends JobState {
  final List<JobModel> jobs;
  JobLoaded(this.jobs);
}
class JobError extends JobState {
  final String message;
  JobError(this.message);
}