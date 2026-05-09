class ApplicationModel {
  final String id;
  final String seekerName;
  final String? seekerAvatarUrl;
  final int aiMatchScore;
  final String appliedAt;

  ApplicationModel({
    required this.id,
    required this.seekerName,
    this.seekerAvatarUrl,
    required this.aiMatchScore,
    required this.appliedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] ?? '',
      seekerName: json['seekerName'] ?? 'No Name',
      seekerAvatarUrl: json['seekerAvatarUrl'],
      aiMatchScore: (json['aiMatchScore'] ?? 0).toInt(),
      appliedAt: json['appliedAt'] ?? '',
    );
  }
}