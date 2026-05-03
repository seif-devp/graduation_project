import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/Home_employer/logic/entity.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/cubit/home_employer_state.dart';

class EmployerHomeCubit extends Cubit<EmployerHomeState> {
  EmployerHomeCubit([employerHomeRepository]) : super(EmployerHomeInitial());

  void getdata() async {
    emit(EmployerHomeLoading());
    try {
      // Use repository integration here. For now return zeroed stats.
      emit(EmployerHomeLoaded(EmployerHomeEntity(
        activeJobs: 0,
        applicantsCount: 0,
        interviewsCount: 0,
        newApplicants: 0,
        interviewsToday: 0,
      )));
    } catch (e) {
      emit(EmployerHomeError("Error loading data"));
    }
  }
}
