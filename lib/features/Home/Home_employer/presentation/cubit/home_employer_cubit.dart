import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/Home_employer/data/repo_imp.dart';
import 'home_employer_state.dart';

class EmployerHomeCubit extends Cubit<EmployerHomeState> {
  final EmployerHomeRepository repo;

  EmployerHomeCubit(this.repo) : super(EmployerHomeInitial());

  Future<void> fetchHomeDataAndJobs() async {
    emit(MyJobsLoading());
    
    // جلب بيانات الإحصائيات والوظائف معاً
    final stats = await repo.getHomeData();
    final jobsResult = await repo.getJobs();

    jobsResult.fold(
      (failure) => emit(MyJobsError(failure.message)),
      (jobsList) => emit(MyJobsSuccess(jobsList: jobsList, stats: stats)),
    );
  }

  Future<void> removeJob(String jobId) async {
    emit(DeleteJobLoading());
    final result = await repo.deleteJob(jobId);
    
    result.fold(
      (failure) => emit(DeleteJobError(failure.message)),
      (success) {
        emit(DeleteJobSuccess());
        fetchHomeDataAndJobs(); // تحديث القائمة فوراً بعد الحذف
      },
    );
  }
}