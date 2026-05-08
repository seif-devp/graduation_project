import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/job_list/data/job_repo_imp.dart';
import 'job_list_state.dart';

class JobSeekerCubit extends Cubit<JobSeekerState> {
  final JobSeekerRepositoryImpl repository;

  JobSeekerCubit(this.repository) : super(JobSeekerInitial());

  Future<void> fetchJobs() async {
    emit(GetJobsLoading());
    final result = await repository.getJobs();
    result.fold(
      (failure) => emit(GetJobsError(failure.message)),
      (jobs) => emit(GetJobsSuccess(jobs)),
    );
  }

  Future<void> filterJobs({String? title, String? location, String? salary,String? type,}) async {
    emit(GetJobsLoading());
    
    final result = await repository.getJobs(
      keyword: title,
      location: location,
      salary: salary,
      type: type,
      
    );

    result.fold(
      (failure) => emit(GetJobsError(failure.message)),
      (jobs) => emit(GetJobsSuccess(jobs)),
    );
  }
}