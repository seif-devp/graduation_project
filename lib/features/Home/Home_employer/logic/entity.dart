// employer_home_entity.dart
class EmployerHomeEntity {
  final int activeJobs;
  final int newApplicants;
  final int interviewsToday;

  EmployerHomeEntity({
    required this.activeJobs,
    required this.newApplicants,
    required this.interviewsToday, required int interviewsCount, required int applicantsCount,
  });
}