import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';

class ApplicantsCubit extends Cubit<ApplicantsState> {
  final ApplicantsRepository repository;

  ApplicantsCubit(this.repository) : super(const ApplicantsState());

  Future<void> loadApplicants(String jobId) async {
    emit(state.copyWith(isLoading: true));
    final result = await repository.getApplicants(jobId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message, // ✅ errorMessage مش error
      )),
      (applicants) => emit(state.copyWith(
        applicants: applicants,
        currentIndex: 0,
        isLoading: false,
      )),
    );
  }

  Future<void> swipeRight() async {
    await _updateAndNext('Shortlisted');
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