

import 'package:graduation_project/features/interviews/interviews_employer/domain/entity.dart';

class InterviewModelEmployer extends InterviewEntityEmployer {
  const InterviewModelEmployer({
    required super.id,
    required super.jobTitle,
    required super.date,
    required super.time,
    required super.type,
    required super.meetingLink,
    required super.status, 
  });
}
