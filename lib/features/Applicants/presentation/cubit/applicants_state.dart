part of 'applicants_cubit.dart';

class ApplicantsState {
  final List<ApplicantEntity> applicants;
  final int currentIndex;

  ApplicantsState({required this.applicants, required this.currentIndex});

  ApplicantsState copyWith({List<ApplicantEntity>? applicants, int? currentIndex}) {
    return ApplicantsState(
      applicants: applicants ?? this.applicants,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}