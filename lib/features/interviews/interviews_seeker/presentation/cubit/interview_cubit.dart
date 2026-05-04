import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/domain/repo.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/presentation/cubit/interview_state.dart';

class InterviewCubit extends Cubit<InterviewState> {
  final Repo repository;

  InterviewCubit(this.repository) : super(InterviewInitial());

  Future<void> loadInterviews() async {
    emit(InterviewLoading());
    try {
      final interviews = await repository.getInterviews();
      if (interviews.isEmpty) {
        emit(InterviewEmpty());
      } else {
        emit(InterviewLoaded(interviews));
      }
    } catch (e) {
      emit(InterviewEmpty());
    }
  }
}
