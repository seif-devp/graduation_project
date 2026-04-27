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
      allJobs = await jobUseCase.getJobList();
      emit(JobListSuccess(allJobs));
    } catch (e) {
      emit(JobListFailure("Error"));
    }
  }

  void filterJobs({String? location, String? salary, String? title}) {
    final filtered = allJobs.where((job) {
  
      bool matchesLocation = location == null || job.location == location;
      bool matchesSalary = salary == null || job.salary == salary;
      bool matchesTitle = title == null || job.title.contains(title);

      return matchesLocation && matchesSalary && matchesTitle;
    }).toList();

    emit(JobListSuccess(filtered));
  }
}