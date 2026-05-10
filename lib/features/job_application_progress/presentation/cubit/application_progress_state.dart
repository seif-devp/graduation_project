import 'package:graduation_project/features/job_application_progress/data/model.dart';

abstract class ApplicationProgressState {}

class ApplicationProgressInitial extends ApplicationProgressState {}

class ApplicationProgressLoading extends ApplicationProgressState {}

class ApplicationProgressLoaded extends ApplicationProgressState {
  final List<SeekerApplicationModel> applications;
  final bool hasReachedMax;

  ApplicationProgressLoaded({
    required this.applications,
    this.hasReachedMax = false,
  });
}

class ApplicationProgressError extends ApplicationProgressState {
  final String message;

  ApplicationProgressError(this.message);
}
