import 'package:graduation_project/features/interviews/interviews_seeker/domain/entity.dart';

abstract class Repo {
  Future<List<InterviewEntity>> getInterviews();
  Future<void> acceptInterview(String id);
  Future<void> rejectInterview(String id);
  Future<InterviewEntity> rescheduleInterview(String id, String proposedAt);
}