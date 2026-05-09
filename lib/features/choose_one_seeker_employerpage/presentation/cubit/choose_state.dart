

import 'package:graduation_project/features/choose_one_seeker_employerpage/data/model.dart';

enum ApplicantDetailsStatus {
  initial,
  loading,
  success,
  error,
}

class ApplicantDetailsState {

  final ApplicantDetailsStatus status;

  final ApplicantDetailsModel?
      applicant;

  final String? errorMessage;

  const ApplicantDetailsState({
    this.status =
        ApplicantDetailsStatus.initial,
    this.applicant,
    this.errorMessage,
  });

  ApplicantDetailsState copyWith({
    ApplicantDetailsStatus? status,
    ApplicantDetailsModel? applicant,
    String? errorMessage,
  }) {

    return ApplicantDetailsState(
      status: status ?? this.status,
      applicant: applicant ?? this.applicant,
      errorMessage:
          errorMessage ?? this.errorMessage,
    );
  }
}