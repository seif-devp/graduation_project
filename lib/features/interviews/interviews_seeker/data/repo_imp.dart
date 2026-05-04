import 'package:graduation_project/features/interviews/interviews_seeker/domain/entity.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/domain/repo.dart';

class RepoImp implements Repo {
  RepoImp();
  
  @override
  Future<List<InterviewEntity>> getInterviews() {
    throw UnimplementedError();
  }
}
