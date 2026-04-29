import 'package:graduation_project/features/Home_employer/logic/entity.dart';

class EmployerHomeRepository {
  Future<EmployerHomeEntity> getHomeData() async {
    await Future.delayed(const Duration(seconds: 1));

    return EmployerHomeEntity(
      activeJobs: 12,
      newApplicants: 48,
      interviewsToday: 3,
      interviewsCount: 50,
      applicantsCount: 28,
    );
  }
}
