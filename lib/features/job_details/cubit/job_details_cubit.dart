import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/remote_source.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/repo.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/job_details/data/model_detail.dart';
import 'package:graduation_project/features/job_details/data/repo_imp_detail.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  final JobDetailsRepo repo;
  final ApplicationRepository applicationRepository = ApplicationRepository(
    ApplicationRemoteDataSource(),
  );

  JobDetailsModel? _currentJob;
  bool _hasApplied = false;

  JobDetailsModel? get currentJob => _currentJob;
  bool get hasApplied => _hasApplied;

  JobDetailsCubit(this.repo) : super(JobDetailsInitial());

  Future<void> fetchJobDetails(String id) async {
    emit(JobDetailsLoading());
    final result = await repo.getJobDetails(id);
    result.fold(
      (failure) => emit(JobDetailsError(failure.message)),
      (job) {
        _currentJob = job;
        emit(JobDetailsSuccess(job));
      },
    );
  }

  Future<void> applyToJob(String jobId) async {
    await CacheHelper.removeData(key: 'resumeId');
    emit(ApplyJobError('Please upload your CV first'));
    if (_currentJob != null) emit(JobDetailsSuccess(_currentJob!));
  }

  Future<void> submitWithResume(String jobId) async {
    final resumeId = CacheHelper.getData(key: 'resumeId');

    if (resumeId == null || resumeId.isEmpty) {
      emit(ApplyJobError('Please upload your CV first'));
      if (_currentJob != null) emit(JobDetailsSuccess(_currentJob!));
      return;
    }

    emit(ApplyJobLoading());
    final result = await applicationRepository.submitApplication(
      jobId: jobId,
      resumeId: resumeId,
    );

    result.fold(
      (failure) {
        emit(ApplyJobError(failure.message));
        if (_currentJob != null) emit(JobDetailsSuccess(_currentJob!));
      },
      (_) {
        _hasApplied = true;
        emit(ApplyJobSuccess());
        if (_currentJob != null) emit(JobDetailsSuccess(_currentJob!));
      },
    );
  }
}