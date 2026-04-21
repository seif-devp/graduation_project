
import 'package:graduation_project/features/interviews/domain/entity.dart';

abstract class Repo {
  Future<List<InterviewEntity>> getInterviews();
}