part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}

final class SignupSuccess extends AuthState {}
