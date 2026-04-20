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
    if (email == 'seif@gmail.com' && password == '123456') {
      emit(AuthSuccess());
    }
  }
}
