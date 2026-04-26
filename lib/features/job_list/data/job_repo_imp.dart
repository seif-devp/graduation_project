import 'package:graduation_project/features/job_list/domain/job_entity.dart';
import 'package:graduation_project/features/job_list/domain/repo_interface.dart';

class JobRepoImp extends Jobrepo {
  @override
  Future<List<JobEntity>> fetchJob() async {
    return [
      JobEntity(
        title: "Senior React Developer",
        company: "TechCorp Inc.",
        address: "San Francisco, CA",
        salary: "\$120k - \$100k",
        percent: "66%",
        date: "1/28/2026",
      ),
      JobEntity(
        title: "Senior flutter Developer",
        company: "TechCorp Inc.",
        address: "San Francisco, CA",
        salary: "\$120k - \$110k",
        percent: "85%",
        date: "1/28/2026",
      ),
      JobEntity(
        title: "Senior web Developer",
        company: "TechCorp Inc.",
        address: "San Francisco, CA",
        salary: "\$120k - \$180k",
        percent: "92%",
        date: "1/28/2026",
      ),
      JobEntity(
        title: "Senior uiux ",
        company: "TechCorp Inc.",
        address: "San Francisco, CA",
        salary: "\$120k - \$120k",
        percent: "60%",
        date: "1/28/2026",
      ),
    ];
  }
}
