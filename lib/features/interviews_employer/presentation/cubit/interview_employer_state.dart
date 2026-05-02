

import 'package:graduation_project/features/interviews_employer/domain/entity.dart';

abstract class InterviewStateEmployer {}

class InterviewEmployerInitial extends InterviewStateEmployer {}

class InterviewEmployerLoading extends InterviewStateEmployer {}

class InterviewEnployerLoaded extends InterviewStateEmployer {
  final List<InterviewEntityEmployer> interviewsEmployer;

  InterviewEnployerLoaded(this.interviewsEmployer);

}

class InterviewEmployerError extends InterviewStateEmployer {
  final String message;
  InterviewEmployerError(this.message);
}