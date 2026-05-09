class JobModelResponse {
  final String id;
  final String title;
  final String companyName;
  final String? companyLogoUrl;
  final String description;
  final List<String> requirements;
  final String location;
  final String salary;
  final String type;
  final String postedAt;
  final int applicationCount;
  final String employerId; // ✅ ضيفنا employerId

  JobModelResponse({
    required this.id,
    required this.title,
    required this.companyName,
    this.companyLogoUrl,
    required this.description,
    required this.requirements,
    required this.location,
    required this.salary,
    required this.type,
    required this.postedAt,
    required this.applicationCount,
    required this.employerId, // ✅
  });

  factory JobModelResponse.fromJson(Map<String, dynamic> json) {
    return JobModelResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      companyName: json['companyName'] ?? '',
      companyLogoUrl: json['companyLogoUrl'],
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      type: json['type'] ?? '',
      postedAt: json['postedAt'] ?? '',
      applicationCount: json['applicationCount'] ?? 0,
      employerId: json['employerId'] ?? '', // ✅
    );
  }
}