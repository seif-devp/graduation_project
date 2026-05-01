import 'package:graduation_project/features/Home_employer/logic/entity.dart';

class EmployerHomeRepository {
  Future<EmployerHomeEntity> getHomeData() async {
    // TODO: connect to backend. Returning zeroed stats instead of sample data.
    return EmployerHomeEntity(
      activeJobs: 0,
      newApplicants: 0,
      interviewsToday: 0,
      interviewsCount: 0,
      applicantsCount: 0,
    );
  }
}
