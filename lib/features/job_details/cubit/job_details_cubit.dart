import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/job_details/data/repo_imp_detail.dart';
import 'package:graduation_project/features/job_details/data/job_application_repo.dart';
import 'package:graduation_project/features/job_details/data/model_detail.dart';
import 'package:graduation_project/features/resume/data/model.dart';
import 'job_details_state.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  final JobDetailsRepo jobRepo;
  final JobApplicationRepository appRepo;

  JobDetailsModel? currentJob;
  bool hasApplied = false;

  JobDetailsCubit(this.jobRepo, this.appRepo) : super(JobDetailsInitial());

  Future<void> fetchJobDetails(String id) async {
    emit(JobDetailsLoading());
    final result = await jobRepo.getJobDetails(id);
    result.fold(
      (failure) => emit(JobDetailsError(failure.message)),
      (job) {
        currentJob = job;
        emit(JobDetailsSuccess(job));
      },
    );
  }

  Future<void> applyWithResume(ResumeModel resume) async {
    if (currentJob == null) return;
    
    emit(ApplyJobLoading());

    // دمج الوصف والمتطلبات عشان نبعتها للـ AI
    final jobText = "${currentJob!.title} ${currentJob!.description} ${currentJob!.requirements.join(' ')}";

    final result = await appRepo.processAndApply(
      jobId: currentJob!.id,
      resumeId: resume.id,
      cvUrl: resume.fileUrl, 
      jobDescription: jobText,
    );

    result.fold(
      (failure) => emit(ApplyJobError(failure.message)),
      (aiData) {
        hasApplied = true;
        emit(ApplyJobSuccess(aiData));
      },
    );
  }
}