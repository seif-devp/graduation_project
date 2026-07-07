import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/Home_employer/data/repo_imp.dart';
import 'package:graduation_project/features/Home/Home_employer/logic/entity.dart';
import 'home_employer_state.dart';

class EmployerHomeCubit extends Cubit<EmployerHomeState> {
  final EmployerHomeRepository repo;

  EmployerHomeCubit(this.repo) : super(EmployerHomeInitial());

  Future<void> fetchHomeDataAndJobs() async {
    emit(MyJobsLoading());

    final jobsResult = await repo.getJobs();

    jobsResult.fold(
      (failure) => emit(MyJobsError(failure.message)),
      (jobsList) {
        
        final activeJobs = jobsList.length;
        final totalApplicants = jobsList.fold<int>(
          0, (sum, job) => sum + job.applicationCount,
        );

        final stats = EmployerHomeEntity(
          activeJobs: activeJobs,
          newApplicants: totalApplicants,
          interviewsToday: 0,
          interviewsCount: 0,
          applicantsCount: totalApplicants,
        );

        emit(MyJobsSuccess(jobsList: jobsList, stats: stats));
      },
    );
  }

  Future<void> removeJob(String jobId) async {
    emit(DeleteJobLoading());
    final result = await repo.deleteJob(jobId);

    result.fold(
      (failure) => emit(DeleteJobError(failure.message)),
      (success) {
        emit(DeleteJobSuccess());
        fetchHomeDataAndJobs();
      },
    );
  }
}