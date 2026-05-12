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
  Future<void> handleInterviewAction(String id, String action, {String? date}) async {
    try {
      if (action == 'accept') {
        await repository.acceptInterview(id);
      } else if (action == 'reject') {
        await repository.rejectInterview(id);
      } else if (action == 'reschedule') {
        await repository.rescheduleInterview(id, date!);
      }
      
      // بعد ما العملية تنجح، بنعمل reload عشان الـ Status يتغير في الـ UI
      await loadInterviews(); 
    } catch (e) {
      emit(InterviewError("Failed to update interview"));
    }
  }
}
