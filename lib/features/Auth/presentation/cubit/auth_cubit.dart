import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/screens/job_seeker_homeScreen.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  void login(
    String email,
    String password,
    bool isEmployer,
    BuildContext context,
  ) {
    emit(AuthLoading());
    Future.delayed(const Duration(seconds: 2));
    if (email == 'seif@gmail.com' && password == '123456') {
      emit(LoginSuccess());
      if (isEmployer) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JobSeekerHomeScreen()),
        );
      }
    }
  }
}
