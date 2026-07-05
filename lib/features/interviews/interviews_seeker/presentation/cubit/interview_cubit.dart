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
      emit(InterviewError(e.toString()));
    }
  }

  Future<void> handleInterviewAction(String id, String action,
      {String? date}) async {
    try {
      if (action == 'accepted') {
        await repository.acceptInterview(id);
      } else if (action == 'rejected') {
        await repository.rejectInterview(id);
      } else if (action == 'reschedule') {
        if (date == null || date.trim().isEmpty) {
          emit(InterviewError('Please choose a new date before rescheduling.'));
          return;
        }
        await repository.rescheduleInterview(id, date);
      }

      await loadInterviews();
    } catch (e) {
      emit(InterviewError('Failed to update interview: ${e.toString()}'));
    }
  }
}
