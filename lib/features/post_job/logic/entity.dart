class JobPostEntity {
  final String title;
  final String companyName;
  final String location;
  final String salaryRange;
  final String jobType;
  final String description;
  final List<String> requirements;

  JobPostEntity({
    required this.title,
    required this.companyName,
    required this.location,
    required this.salaryRange,
    required this.jobType,
    required this.description,
    required this.requirements,
  });
}