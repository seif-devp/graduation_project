class ApplicantDetailsModel {

  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String seekerId;
  final String seekerName;
  final String? seekerAvatarUrl;
  final String resumeId;
  final String resumeFileName;
  final String status;
  final int aiMatchScore;
  final String appliedAt;
  final String updatedAt;

  ApplicantDetailsModel({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.seekerId,
    required this.seekerName,
    this.seekerAvatarUrl,
    required this.resumeId,
    required this.resumeFileName,
    required this.status,
    required this.aiMatchScore,
    required this.appliedAt,
    required this.updatedAt,
  });

  factory ApplicantDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ApplicantDetailsModel(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      companyName: json['companyName'] ?? '',
      seekerId: json['seekerId'] ?? '',
      seekerName: json['seekerName'] ?? '',
      seekerAvatarUrl: json['seekerAvatarUrl'],
      resumeId: json['resumeId'] ?? '',
      resumeFileName: json['resumeFileName'] ?? '',
      status: json['status'] ?? '',
      aiMatchScore: (json['aiMatchScore'] ?? 0).toInt(),
      appliedAt: json['appliedAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}