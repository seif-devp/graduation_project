import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  void login({
    required String email,
    required String password,
    required bool isEmployer,
  }) {
    emit(AuthLoading());
    Future.delayed(const Duration(seconds: 2));
    if (email == ' ' && password == ' ') {
      emit(AuthSuccess());
    }
  }
  void register({
    required String name, 
    required String email,
    required String password,
    required bool isEmployer,
  }) {
    emit(AuthLoading());
    Future.delayed(const Duration(seconds: 2));
    if (email == ' ' && password == ' ') {
      emit(AuthSuccess());
    }
  }
}
