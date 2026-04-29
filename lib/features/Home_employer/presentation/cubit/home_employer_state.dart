import 'package:graduation_project/features/Home_employer/logic/entity.dart';

abstract class EmployerHomeState {}

class EmployerHomeInitial extends EmployerHomeState {}

class EmployerHomeLoading extends EmployerHomeState {}

class EmployerHomeLoaded extends EmployerHomeState {
  final EmployerHomeEntity data;
  EmployerHomeLoaded(this.data);
}

class EmployerHomeError extends EmployerHomeState {
  final String message;
  EmployerHomeError(this.message);
}