import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Applicants/logic/entity.dart';


part 'applicants_state.dart';

class ApplicantsCubit extends Cubit<ApplicantsState> {
  ApplicantsCubit() : super(ApplicantsState(applicants: [], currentIndex: 0));

  void loadInitialData() {
    final mockData = [
      // ضفنا التاريخ والاسكور هنا
      ApplicantEntity(id: '1', name: 'Sarah Jenkins', experience: '4', appliedDate: '2/1/2026', matchScore: 92),
      ApplicantEntity(id: '2', name: 'Mike Ross', experience: '5', appliedDate: '3/1/2026', matchScore: 85),
    ];
    
    emit(state.copyWith(applicants: mockData, currentIndex: 0));
  }
  void swipeRight() {
    final current = state.applicants[state.currentIndex];

    _moveToNext();
  }

  void swipeLeft() {
    final current = state.applicants[state.currentIndex];
      _moveToNext();
  }

  void _moveToNext() {
    if (state.currentIndex < state.applicants.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    } else {
      emit(state.copyWith(applicants: []));
    }
  }
}