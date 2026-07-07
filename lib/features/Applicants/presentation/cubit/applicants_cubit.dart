import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Applicants/data/model_view_data.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';

class ApplicantsCubit extends Cubit<ApplicantsState> {
  final ApplicantsRepository repository;

  ApplicantsCubit(this.repository) : super(const ApplicantsState());

  // 🔥 الدالة المطلوبة لشاشة الـ JobPageEmployer
  Future<void> fetchAllJobs() async {
    emit(state.copyWith(jobsStatus: JobsStatus.loading));
    try {
      final result = await repository.getEmployerJobs();

      // ✅ الحماية من الكراش لو الشاشة اتقفلت قبل ما السيرفر يرد
      if (isClosed) return; 

      result.fold(
        (failure) => emit(state.copyWith(jobsStatus: JobsStatus.failure)),
        (jobsList) => emit(state.copyWith(jobsStatus: JobsStatus.success, jobs: jobsList)),
      );
    } catch (e) {
      try {
        final dynamic jobsList = await (repository as dynamic).getEmployerJobs();
        
        // ✅ الحماية
        if (isClosed) return; 

        emit(state.copyWith(jobsStatus: JobsStatus.success, jobs: jobsList));
      } catch (_) {
        if (isClosed) return;
        emit(state.copyWith(jobsStatus: JobsStatus.failure));
      }
    }
  }

  // دالة تحميل المتقدمين لشاشة الـ Applicants
  Future<void> loadApplicants(String jobId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final result = await repository.getApplicants(jobId);

      // ✅ الحماية هنا كمان
      if (isClosed) return;

      result.fold(
        (failure) {
          emit(state.copyWith(isLoading: false, errorMessage: failure.toString()));
        },
        (applicantsList) {
          emit(state.copyWith(
            isLoading: false,
            applicants: applicantsList,
            currentIndex: 0,
            errorMessage: null,
          ));
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> markAsViewed(ApplicationModel applicant) async {
    if (applicant.status.toLowerCase() == 'viewed' ||
        applicant.status.toLowerCase() == 'accepted' ||
        applicant.status.toLowerCase() == 'rejected') return;
    try {
      await repository.updateStatus(applicant.id, 'viewed');
    } catch (e) {
      print("Error marking as viewed: $e");
    }
  }

  void swipeLeft() {
    if (state.currentIndex < state.applicants.length) {
      final currentApplicant = state.applicants[state.currentIndex];
      updateApplicationStatus(currentApplicant.id, 'rejected');
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void swipeRight() {
    if (state.currentIndex < state.applicants.length) {
      final currentApplicant = state.applicants[state.currentIndex];
      updateApplicationStatus(currentApplicant.id, 'accepted');
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  Future<void> updateApplicationStatus(String id, String status) async {
    try {
      await repository.updateStatus(id, status);
    } catch (e) {
      print("Error updating status: $e");
    }
  }
}