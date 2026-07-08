class JobResponseModel {
  final List<JobModel> items;
  final int totalCount;

  JobResponseModel({required this.items, required this.totalCount});

  factory JobResponseModel.fromJson(Map<String, dynamic> json) {
    return JobResponseModel(
      items: (json['items'] as List).map((e) => JobModel.fromJson(e)).toList(),
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

class JobModel {
  final String id;
  final String companyName;
  final String? companyLogoUrl; // التعديل هنا: خليناها String?
  final String title;
  final String description;
  final List<String> requirements;
  final String location;
  final String salary;
  final String type;

  JobModel({
    required this.id,
    required this.companyName,
    this.companyLogoUrl, // التعديل هنا
    required this.title,
    required this.description,
    required this.requirements,
    required this.location,
    required this.salary,
    required this.type,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    // تظبيط مسار اللوجو عشان يقرأ من السيرفر صح
    String? rawLogo = json['companyLogoUrl'];
    String? fullLogoUrl;
    
    if (rawLogo != null && rawLogo.isNotEmpty) {
      if (rawLogo.startsWith('http')) {
        fullLogoUrl = rawLogo;
      } else {
        fullLogoUrl = 'https://smartjop.runasp.net$rawLogo';
      }
    }

    return JobModel(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      companyLogoUrl: fullLogoUrl, // التعديل هنا
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      type: json['type'] ?? '',
    );
  }
}