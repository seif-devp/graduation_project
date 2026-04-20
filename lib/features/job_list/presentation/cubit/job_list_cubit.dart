

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';
import 'package:graduation_project/features/job_list/domain/job_use_case.dart';

part 'job_list_state.dart';

class JobListCubit extends Cubit<JobListState> {
  final JobUseCase jobUseCase;
  JobListCubit(this.jobUseCase) : super(JobListInitial());

  Future<void> fetchJob() async {
    emit(JobListLoading());
    try {
      final jobs = await jobUseCase.getJobList();
      emit(JobListSuccess(jobs));
    } catch (e) {
      emit(JobListFailure("error try agian"));
    }
  }
}
