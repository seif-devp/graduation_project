import 'package:graduation_project/features/Applicants/logic/entity.dart';

class ApplicantsState {
  final List<ApplicantEntity> applicants;
  final int currentIndex;

  const ApplicantsState({
    required this.applicants,
    required this.currentIndex,
  });

  ApplicantsState copyWith({
    List<ApplicantEntity>? applicants,
    int? currentIndex,
  }) {
    return ApplicantsState(
      applicants: applicants ?? this.applicants,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}