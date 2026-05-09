part of 'seeker_application_cubit.dart';

abstract class SeekerApplicationState {}

class SeekerApplicationInitial extends SeekerApplicationState {}

class SeekerApplicationLoading extends SeekerApplicationState {}

class SeekerApplicationPaginationLoading extends SeekerApplicationState {}

class SeekerApplicationSuccess extends SeekerApplicationState {}

class SeekerApplicationError extends SeekerApplicationState {
  final String message;

  SeekerApplicationError(this.message);
}