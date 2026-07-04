class ApplicationResponseModel {
  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String seekerId;
  final String seekerName;
  final String seekerAvatarUrl;
  final String resumeId;
  final String resumeFileName;
  final String status;
  final int aiMatchScore;
  final DateTime appliedAt;
  final DateTime updatedAt;

  ApplicationResponseModel({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.seekerId,
    required this.seekerName,
    required this.seekerAvatarUrl,
    required this.resumeId,
    required this.resumeFileName,
    required this.status,
    required this.aiMatchScore,
    required this.appliedAt,
    required this.updatedAt,
  });

  factory ApplicationResponseModel.fromJson(Map<String, dynamic> json) {
    return ApplicationResponseModel(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      companyName: json['companyName'] ?? '',
      seekerId: json['seekerId'] ?? '',
      seekerName: json['seekerName'] ?? '',
      seekerAvatarUrl: json['seekerAvatarUrl'] ?? '',
      resumeId: json['resumeId'] ?? '',
      resumeFileName: json['resumeFileName'] ?? '',
      status: json['status'] ?? '',
      aiMatchScore: (json['aiMatchScore'] ?? json['aiScore'] ?? 0 as num).toInt(), // ✅ تحويل آمن لمنع الـ 0%
      appliedAt: json['appliedAt'] != null ? DateTime.parse(json['appliedAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}