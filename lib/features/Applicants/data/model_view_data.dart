import 'package:graduation_project/features/Applicants/logic/entity.dart';

class ApplicationModel {
  final String id;
  final String seekerName;
  final String? seekerAvatarUrl;
  final int aiMatchScore;
  final String appliedAt;
  final String status;

  ApplicationModel({
    required this.id,
    required this.seekerName,
    this.seekerAvatarUrl,
    required this.aiMatchScore,
    required this.appliedAt,
    required this.status,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] ?? '',
      seekerName: json['seekerName'] ?? 'No Name',
      seekerAvatarUrl: json['seekerAvatarUrl'],
      aiMatchScore: (json['aiMatchScore'] ?? 0).toInt(),
      appliedAt: json['appliedAt'] ?? '',
      status: json['status'] ?? 'Pending', 
    );
  }
  ApplicantEntity toEntity() {
  return ApplicantEntity(
    id: id,
    name: seekerName, matchScore: aiMatchScore, appliedDate: '',
    // كمل باقي الحقول اللي موجودة في الـ Entity بتاعك
  );
}
}