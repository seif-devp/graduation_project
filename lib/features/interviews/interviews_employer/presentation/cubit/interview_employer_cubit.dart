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
      final List<InterviewEntityEmployer> interviews;
      interviews =
          await repositoryemployer.getInterviewsByJobId(jobId, page, pageSize);
      emit(InterviewEmployerLoaded(interviews));
      if (interviews.isEmpty) {
        emit(InterviewsEmployerEmpty());
      }
    } catch (e) {
      //TODO don't forget handel error state
      emit(InterviewEmployerError(e.toString()));
    }
  }
}
