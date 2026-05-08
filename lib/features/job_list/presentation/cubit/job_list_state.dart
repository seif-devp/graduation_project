import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';


abstract class JobSeekerState extends Equatable {
  const JobSeekerState();
  @override
  List<Object?> get props => [];
}

class JobSeekerInitial extends JobSeekerState {}

class GetJobsLoading extends JobSeekerState {}

class GetJobsSuccess extends JobSeekerState {
  final List<JobModelResponse> jobs;
  const GetJobsSuccess(this.jobs);
  @override
  List<Object?> get props => [jobs];
}

class GetJobsError extends JobSeekerState {
  final String message;
  const GetJobsError(this.message);
  @override
  List<Object?> get props => [message];
}