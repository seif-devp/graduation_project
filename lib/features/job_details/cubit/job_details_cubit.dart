import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/job_details/data/repo_imp_detail.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  final JobDetailsRepo repo;
  JobDetailsCubit(this.repo) : super(JobDetailsInitial());

  Future<void> fetchJobDetails(String id) async {
    emit(JobDetailsLoading());
    final result = await repo.getJobDetails(id);
    result.fold(
      (failure) => emit(JobDetailsError(failure.message)),
      (job) => emit(JobDetailsSuccess(job)),
    );
  }
}