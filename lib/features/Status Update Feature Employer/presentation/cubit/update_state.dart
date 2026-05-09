
import 'package:graduation_project/features/Status%20Update%20Feature%20Employer/data/model.dart';

class ApplicantsState {
  final List<ApplicantResponseModel> applicants;
  final int currentIndex;
  final bool isLoading;
  final String? error;

  const ApplicantsState({
    required this.applicants,
    required this.currentIndex,
    this.isLoading = false,
    this.error,
  });

  ApplicantsState copyWith({
    List<ApplicantResponseModel>? applicants,
    int? currentIndex,
    bool? isLoading,
    String? error,
  }) {
    return ApplicantsState(
      applicants: applicants ?? this.applicants,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}