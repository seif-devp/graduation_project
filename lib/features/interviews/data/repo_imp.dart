import 'package:graduation_project/features/interviews/domain/entity.dart';
import 'package:graduation_project/features/interviews/domain/repo.dart';

class RepoImp implements Repo {
  RepoImp();

  @override
  Future<List<InterviewEntity>> getInterviews() async {
    // TODO: implement interviews repository fetching. Returning empty list
    // to avoid shipping fake/sample interview data.
    return [];
  }
}
