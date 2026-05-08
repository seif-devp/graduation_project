class JobRequestModel {
  final String title;
  final String description;
  final List<String> requirements;
  final String location;
  final String salary;
  final String type;
  final String expiresAt; 

  JobRequestModel({
    required this.title,
    required this.description,
    required this.requirements,
    required this.location,
    required this.salary,
    required this.type,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "requirements": requirements,
      "location": location,
      "salary": salary,
      "type": type,
      "expiresAt": expiresAt,
    };
  }
}