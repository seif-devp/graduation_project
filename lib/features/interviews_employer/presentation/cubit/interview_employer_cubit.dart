import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/interviews_employer/domain/repo.dart';
import 'package:graduation_project/features/interviews_employer/presentation/cubit/interview_employer_state.dart';

class InterviewCubitEmployer extends Cubit<InterviewStateEmployer> {
  final RepoEmployer repositoryemployer;

  InterviewCubitEmployer(this.repositoryemployer) : super(InterviewEmployerInitial());

  Future<void> loadInterviews() async {
    emit(InterviewEmployerLoading());
    try {
      await repositoryemployer.getInterviewsEmploer();
      emit(InterviewEnployerLoaded([]));
    } catch (e) {
      emit(InterviewEmployerError('Failed to load interviews'));
    }
  }
}