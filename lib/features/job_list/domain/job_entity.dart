
class JobEntity {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String salary;
  final String type;
  final String companyLogoUrl;

  JobEntity({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.type,
    required this.companyLogoUrl,
  });
}