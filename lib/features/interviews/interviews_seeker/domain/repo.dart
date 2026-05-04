
import 'package:graduation_project/features/interviews/interviews_seeker/domain/entity.dart';

abstract class Repo {
  Future<List<InterviewEntity>> getInterviews();
}