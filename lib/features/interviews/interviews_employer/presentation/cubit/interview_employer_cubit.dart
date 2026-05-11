import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/interviews/interviews_employer/domain/entity.dart';
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
      final interviews =
          await repositoryemployer.getInterviewsByJobId(jobId, page, pageSize);
          
      if (interviews.isEmpty) {
        emit(InterviewsEmployerEmpty());
      } else {
        emit(InterviewEmployerLoaded(interviews));
      }
    } catch (e) {
      emit(InterviewsEmployerEmpty());
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
  
}