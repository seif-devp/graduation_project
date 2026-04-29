import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home_employer/logic/entity.dart';
import 'package:graduation_project/features/Home_employer/presentation/cubit/home_employer_state.dart';

class EmployerHomeCubit extends Cubit<EmployerHomeState> {
  EmployerHomeCubit([employerHomeRepository]) : super(EmployerHomeInitial());

  void getdata() async {
    emit(EmployerHomeLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(EmployerHomeLoaded(EmployerHomeEntity(
        activeJobs: 12,
        applicantsCount: 48,
        interviewsCount: 3,
        newApplicants: 2,
        interviewsToday: 4,
      )));
    } catch (e) {
      emit(EmployerHomeError("Error loading data"));
    }
  }
}
