import 'package:graduation_project/features/interviews/interviews_employer/domain/entity.dart';


abstract class InterviewsRepository {
  Future<List<InterviewEntityEmployer>> getInterviewsByJobId(String jobId, int page, int pageSize);
}