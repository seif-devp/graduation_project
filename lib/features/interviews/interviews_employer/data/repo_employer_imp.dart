import 'package:graduation_project/features/interviews/interviews_employer/data/models/model.dart';
import 'package:graduation_project/features/interviews/interviews_employer/data/services/interview_endpoint.dart';
import 'package:graduation_project/features/interviews/interviews_employer/domain/entity.dart';
import 'package:graduation_project/features/interviews/interviews_employer/domain/repo.dart';

class InterviewsRepositoryImpl implements InterviewsRepository {
  final InterviewEndpoint endpoint;

  InterviewsRepositoryImpl({InterviewEndpoint? endpoint})
      : endpoint = endpoint ?? InterviewEndpoint();

  @override
  Future<List<InterviewEntityEmployer>> getInterviewsByJobId(
      String jobId, int page, int pageSize) async {
    try {
      final Map<String, dynamic> data = await endpoint.getInterviewsJobID(
        jobId: jobId,
        page: page,
        pageSize: pageSize,
      );

      final InterviewModelEmployer model =
          InterviewModelEmployer.fromJson(data);

      final List<InterviewEntityEmployer> entities = model.items.map((item) {
        return item.toEntity();
      }).toList();

      return entities;
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<InterviewEntityEmployer>> getallInterviews(
      List<String> jobIds, int page, int pageSize) async {
    try {
      final futures = jobIds.map((jobId) => getInterviewsByJobId(jobId, page, pageSize));
      
      final List<List<InterviewEntityEmployer>> results = await Future.wait(futures);
      
      final List<InterviewEntityEmployer> flattenedInterviews = results.expand((list) => list).toList();
      
      return flattenedInterviews;
    } catch (e) {
      rethrow;
    }
  }
}
