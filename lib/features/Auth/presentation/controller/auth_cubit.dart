import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  void login({
    String email = '',
    String password = '',
    required bool isEmployer,
  }) {
    emit(AuthLoading());
    emit(AuthSuccess());
    // Authentication is not yet implemented. Emit failure for now.
    emit(AuthFailure('Not implemented: connect to auth service'));
  }

  void register({
    required String name,
    required String email,
    required String password,
    required bool isEmployer,
  }) {
    emit(AuthLoading());
    emit(AuthFailure('Not implemented: connect to auth service'));
  }
}
