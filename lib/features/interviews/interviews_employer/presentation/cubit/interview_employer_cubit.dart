import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/Home_employer/data/remote_data_source_eployer.dart';
import 'package:graduation_project/features/Home/Home_employer/data/repo_imp.dart';
import 'package:graduation_project/features/interviews/interviews_employer/domain/repo.dart';
import 'package:graduation_project/features/interviews/interviews_employer/presentation/cubit/interview_employer_state.dart';

class InterviewCubitEmployer extends Cubit<InterviewStateEmployer> {
  final InterviewsRepository repositoryemployer;

  InterviewCubitEmployer(this.repositoryemployer)
      : super(InterviewEmployerInitial());

  Future<void> loadInterviewsOneJob(
      String jobId, int page, int pageSize) async {
    emit(InterviewEmployerLoading());
    try {
      if (jobId.trim().isEmpty) {
        emit(InterviewsEmployerEmpty());
        return;
      }

      final interviews =
          await repositoryemployer.getInterviewsByJobId(jobId, page, pageSize);

      if (interviews.isEmpty) {
        emit(InterviewsEmployerEmpty());
      } else {
        emit(InterviewEmployerLoaded(interviews));
      }
    } catch (e) {
      emit(InterviewEmployerError(e.toString()));
    }
  }

  Future<void> loadAllInterviews(
      List<String> jobIds, int page, int pageSize) async {
    emit(InterviewEmployerLoading());
    try {
      final interviews =
          await repositoryemployer.getallInterviews(jobIds, page, pageSize);

      if (interviews.isEmpty) {
        emit(InterviewsEmployerEmpty());
      } else {
        interviews.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        emit(InterviewEmployerLoaded(interviews));
      }
    } catch (e) {
      emit(InterviewEmployerError(e.toString()));
    }
  }

  Future<void> loadAllInterviewsForEmployer(
      {int page = 1, int pageSize = 10}) async {
    emit(InterviewEmployerLoading());
    try {
      final employerRepo = EmployerHomeRepository(RemoteDataSourceEployer());
      final jobsResult = await employerRepo.getJobs();

      final jobIds = jobsResult.fold<List<String>>(
        (failure) => <String>[],
        (jobs) => jobs.map((job) => job.id).toList(),
      );

      if (jobIds.isEmpty) {
        emit(InterviewsEmployerEmpty());
        return;
      }

      await loadAllInterviews(jobIds, page, pageSize);
    } catch (e) {
      emit(InterviewEmployerError(e.toString()));
    }
  }
}
