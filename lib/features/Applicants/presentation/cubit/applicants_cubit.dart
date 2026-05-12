import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class ApplicantsCubit extends Cubit<ApplicantsState> {
  final ApplicantsRepository repository;

  ApplicantsCubit(this.repository) : super(const ApplicantsState());

  Future<void> fetchAllJobs() async {
    emit(state.copyWith(jobsStatus: JobsStatus.loading));
    try {
      final response = await DioFactory.getDio().get('/api/jobs');
      final items = response.data['items'] as List;
      final jobs = items.map((e) => JobModelResponse.fromJson(e)).toList();
      emit(state.copyWith(
        jobs: jobs,
        jobsStatus: JobsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        jobsStatus: JobsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadApplicants(String jobId) async {
    emit(state.copyWith(isLoading: true));
    final result = await repository.getApplicants(jobId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (applicants) => emit(state.copyWith(
        applicants: applicants,
        currentIndex: 0,
        isLoading: false,
      )),
    );
  }

  Future<void> swipeRight() async {
    await _updateAndNext('accepted');
  }

  Future<void> swipeLeft() async {
    await _updateAndNext('Rejected');
  }

  Future<void> _updateAndNext(String status) async {
    if (state.applicants.isEmpty) return;
    final current = state.applicants[state.currentIndex];
    await repository.updateStatus(current.id, status);
    _nextApplicant();
  }

  void _nextApplicant() {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.applicants.length) {
      emit(state.copyWith(applicants: []));
    } else {
      emit(state.copyWith(currentIndex: nextIndex));
    }
  }
}
