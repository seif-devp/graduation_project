import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/repo_imp_recomend.dart';

import 'package:graduation_project/features/Home/home_seeker/presentation/controller/job_Seeker_state.dart';

class JobSeekerCubit extends Cubit<JobState> {
  final HomeSeekerRepoImpl repo;
  JobSeekerCubit(this.repo) : super(JobInitial());

  Future<void> loadJobs() async {
    emit(JobLoading());
    final result = await repo.getJobsRecomend();
    result.fold(
      (failure) => emit(JobError(failure.message)),
      (jobsList) => emit(JobLoaded(jobsList)),
    );
  }
}