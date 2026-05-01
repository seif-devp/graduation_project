class ApplicantEntity {
  final String id;
  final String name;
  final String experience;
  final int matchScore;
  final String appliedDate;

  ApplicantEntity(
      {required this.id,
      required this.name,
      required this.experience,
      required this.matchScore, required this.appliedDate});
}
