

import 'package:graduation_project/features/interviews/interviews_employer/domain/entity.dart';

abstract class InterviewStateEmployer {}

class InterviewEmployerInitial extends InterviewStateEmployer {}

class InterviewEmployerLoading extends InterviewStateEmployer {}

class InterviewEmployerLoaded extends InterviewStateEmployer {
  final List<InterviewEntityEmployer> interviewsEmployer;

  InterviewEmployerLoaded(this.interviewsEmployer);

}

class InterviewEmployerError extends InterviewStateEmployer {
  final String message;
  InterviewEmployerError(this.message);
}
class InterviewsEmployerEmpty extends InterviewStateEmployer
{}