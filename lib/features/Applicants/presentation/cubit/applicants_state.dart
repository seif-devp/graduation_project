import 'package:graduation_project/features/Applicants/data/model_view_data.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

enum JobsStatus { initial, loading, success, error }

class ApplicantsState {
  final List<ApplicationModel> applicants;
  final int currentIndex;
  final bool isLoading;
  final String? errorMessage;
  final List<JobModelResponse> jobs;
  final JobsStatus jobsStatus;

  const ApplicantsState({
    this.applicants = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.errorMessage,
    this.jobs = const [],
    this.jobsStatus = JobsStatus.initial,
  });

  ApplicantsState copyWith({
    List<ApplicationModel>? applicants,
    int? currentIndex,
    bool? isLoading,
    String? errorMessage,
    List<JobModelResponse>? jobs,
    JobsStatus? jobsStatus,
  }) {
    return ApplicantsState(
      applicants: applicants ?? this.applicants,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      jobs: jobs ?? this.jobs,
      jobsStatus: jobsStatus ?? this.jobsStatus,
    );
  }
}