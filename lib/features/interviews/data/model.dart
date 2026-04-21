
import 'package:graduation_project/features/interviews/domain/entity.dart';

class InterviewModel extends InterviewEntity {
  const InterviewModel({
    required super.id,
    required super.jobTitle,
    required super.company,
    required super.date,
    required super.time,
    required super.type,
    required super.meetingLink,
    required super.status,
  });
}
