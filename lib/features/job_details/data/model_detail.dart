class JobDetailsModel {
  final String id;
  final String companyName;
  final String title;
  final String description;
  final List<String> requirements;
  final String location;
  final String salary;
  final String type;
  final int applicationCount;

  JobDetailsModel({
    required this.id, required this.companyName, required this.title,
    required this.description, required this.requirements, required this.location,
    required this.salary, required this.type, required this.applicationCount,
  });

  factory JobDetailsModel.fromJson(Map<String, dynamic> json) {
    return JobDetailsModel(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      type: json['type'] ?? '',
      applicationCount: json['applicationCount'] ?? 0,
    );
  }
}