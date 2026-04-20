part of 'job_list_cubit.dart';

abstract class JobListState extends Equatable {
  const JobListState();

  @override
  List<Object> get props => [];
}

final class JobListInitial extends JobListState {}

final class JobListSuccess extends JobListState {
  final List<JobEntity> jobs;
  const JobListSuccess(this.jobs);

  @override
  List<Object> get props => [jobs];
}

final class JobListFailure extends JobListState {
  final String massege;
  const JobListFailure(this.massege);

  @override
  List<Object> get props => [massege];
}

final class JobListLoading extends JobListState {}
