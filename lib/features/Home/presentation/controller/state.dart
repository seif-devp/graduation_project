import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/Home/Data/models/jobmodel.dart';

abstract class JobState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final List<JobModel> jobs;

  JobLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class JobError extends JobState {
  final String message;

  JobError(this.message);

  @override
  List<Object?> get props => [message];
}
