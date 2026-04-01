import 'package:graduation_project/features/job_list/domain/job_entity.dart';
import 'package:graduation_project/features/job_list/domain/repo_interface.dart';

class JobUseCase {
  final Jobrepo rebositry;
  JobUseCase(this.rebositry);

  Future<List<JobEntity>> getJobList() async {
    return await rebositry.fetchJob();
  }
}
