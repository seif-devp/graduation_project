import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';
import 'package:graduation_project/features/job_list/domain/job_use_case.dart';

part 'job_list_state.dart';

class JobListCubit extends Cubit<JobListState> {
  final JobUseCase jobUseCase;

  List<JobEntity> allJobs = []; 

  JobListCubit(this.jobUseCase) : super(JobListInitial());

  Future<void> fetchJob() async {
    emit(JobListLoading());
    try {
      final jobs = await jobUseCase.getJobList();
      allJobs = jobs; 
      emit(JobListSuccess(jobs));
    } catch (e) {
      emit(JobListFailure("error try agian"));
    }
  }

  
  void filterByLocation(String location) {
    if (location.isEmpty) {
      emit(JobListSuccess(allJobs)); 
      return;
    }

    final filteredList = allJobs.where((job) {
      return job.address.toLowerCase().contains(location.toLowerCase());
    }).toList();

    emit(JobListSuccess(filteredList)); 
  }
}