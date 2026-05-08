import '../../logic/entity.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

abstract class EmployerHomeState {}
class EmployerHomeInitial extends EmployerHomeState {}
class MyJobsLoading extends EmployerHomeState {}
class MyJobsSuccess extends EmployerHomeState {
  final List<JobModelResponse> jobsList;
  final EmployerHomeEntity stats;
  MyJobsSuccess({required this.jobsList, required this.stats});
}
class MyJobsError extends EmployerHomeState {
  final String message;
  MyJobsError(this.message);
}
class DeleteJobLoading extends EmployerHomeState {}
class DeleteJobSuccess extends EmployerHomeState {}
class DeleteJobError extends EmployerHomeState {
  final String message;
  DeleteJobError(this.message);
}