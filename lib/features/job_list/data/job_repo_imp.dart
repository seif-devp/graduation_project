import 'package:graduation_project/features/job_list/domain/job_entity.dart';
import 'package:graduation_project/features/job_list/domain/repo_interface.dart';

class JobRepoImp extends Jobrepo {
  @override
  Future<List<JobEntity>> fetchJob() async {
    // Return empty list by default. Wire to real job service later.
    return [];
  }
}
