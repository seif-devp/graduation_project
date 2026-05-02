
import 'package:graduation_project/features/interviews_employer/domain/entity.dart';

abstract class RepoEmployer {
  Future<List<InterviewEntityEmployer>> getInterviewsEmploer();
}