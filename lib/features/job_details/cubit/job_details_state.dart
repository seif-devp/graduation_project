import 'package:graduation_project/features/job_details/data/model_detail.dart';

abstract class JobDetailsState {}
class JobDetailsInitial extends JobDetailsState {}
class JobDetailsLoading extends JobDetailsState {}
class JobDetailsSuccess extends JobDetailsState {
  final JobDetailsModel job;
  JobDetailsSuccess(this.job);
}
class JobDetailsError extends JobDetailsState {
  final String message;
  JobDetailsError(this.message);
}