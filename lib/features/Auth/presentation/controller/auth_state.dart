part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final int role; // 0 for job seeker, 1 for employer
  final String token;
  AuthSuccess({required this.role, required this.token});
}

final class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}

final class SignupSuccess extends AuthState {
  final int role; 
  final String token;
  SignupSuccess({required this.role, required this.token});
}