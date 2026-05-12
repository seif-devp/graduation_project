import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';
import 'package:graduation_project/features/Applicants/data/model_view_data.dart';
import 'package:graduation_project/core/networking/dio.dart';
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
      emit(state.copyWith(jobs: jobs, jobsStatus: JobsStatus.success));
    } catch (e) {
      emit(state.copyWith(jobsStatus: JobsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> loadApplicants(String jobId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await repository.getApplicants(jobId);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (applicants) => emit(state.copyWith(
        applicants: List<ApplicationModel>.from(applicants),
        currentIndex: 0,
        isLoading: false,
      )),
    );
  }

  Future<void> swipeRight() async => _updateAndNext('accepted');
  Future<void> swipeLeft() async => _updateAndNext('rejected');

  Future<void> _updateAndNext(String status) async {
    if (state.applicants.isEmpty) return;
    final currentApplicant = state.applicants[state.currentIndex];
    final updatedList = List<ApplicationModel>.from(state.applicants);
    updatedList.removeAt(state.currentIndex);

    emit(state.copyWith(
      applicants: updatedList,
      currentIndex: (updatedList.isEmpty) ? 0 : (state.currentIndex >= updatedList.length ? 0 : state.currentIndex),
    ));

    await repository.updateStatus(currentApplicant.id, status);
  }

  Future<void> markAsViewed(ApplicationModel applicant) async {
    final s = applicant.status.toLowerCase();
    if (s != 'sent' && s != 'pending') return;
    try {
      await repository.updateStatus(applicant.id, 'viewed');
    } catch (e) {
      print(e);
    }
  }
}