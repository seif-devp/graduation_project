import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/models/jobmodel.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object?> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final List<JobModelHome> jobs;

  const JobLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs]; // تمرير القائمة هنا للمقارنة
}

class JobError extends JobState {
  final String message;

  const JobError(this.message);

  @override
  List<Object?> get props => [message]; // تمرير الرسالة هنا
}