import 'package:graduation_project/features/Applicants/data/model_view_data.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

enum JobsStatus { initial, loading, success, error }

class ApplicantsState {
  final List<ApplicationModel> applicants;
  final List<JobModelResponse> jobs;
  final int currentIndex;
  final bool isLoading;
  final String? errorMessage;
  final JobsStatus jobsStatus;

  const ApplicantsState({
    this.applicants = const [],
    this.jobs = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.errorMessage,
    this.jobsStatus = JobsStatus.initial,
  });

  ApplicantsState copyWith({
    List<ApplicationModel>? applicants,
    List<JobModelResponse>? jobs,
    int? currentIndex,
    bool? isLoading,
    String? errorMessage,
    JobsStatus? jobsStatus,
  }) {
    return ApplicantsState(
      applicants: applicants ?? this.applicants,
      jobs: jobs ?? this.jobs,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      jobsStatus: jobsStatus ?? this.jobsStatus,
    );
  }
}