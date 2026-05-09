import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Applicants/logic/entity.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';

class ApplicantsCubit extends Cubit<ApplicantsState> {
  ApplicantsCubit() : super(const ApplicantsState(applicants: [], currentIndex: 0));

  void loadInitialData() {
    // ✅ بيانات وهمية مؤقتاً
    final mockApplicants = [
      ApplicantEntity(
        id: '1',
        name: 'Ahmed Mohamed',
        experience: '3',
        matchScore: 85,
        appliedDate: '2026-05-01',
      ),
      ApplicantEntity(
        id: '2',
        name: 'Sara Ali',
        experience: '5',
        matchScore: 92,
        appliedDate: '2026-05-02',
      ),
      ApplicantEntity(
        id: '3',
        name: 'Omar Hassan',
        experience: '2',
        matchScore: 70,
        appliedDate: '2026-05-03',
      ),
      ApplicantEntity(
        id: '4',
        name: 'Nour Khaled',
        experience: '4',
        matchScore: 78,
        appliedDate: '2026-05-04',
      ),
    ];

    emit(state.copyWith(applicants: mockApplicants, currentIndex: 0));
  }

  void swipeRight() {
    // ✅ Shortlist - بنعدي للكارت الجاي
    _nextApplicant();
  }

  void swipeLeft() {
    // ✅ Reject - بنعدي للكارت الجاي
    _nextApplicant();
  }

  void _nextApplicant() {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.applicants.length) {
      // ✅ خلصت الـ applicants - بنبعت list فاضية
      emit(state.copyWith(applicants: []));
    } else {
      emit(state.copyWith(currentIndex: nextIndex));
    }
  }
}