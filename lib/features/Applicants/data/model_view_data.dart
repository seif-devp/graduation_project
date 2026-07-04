class ApplicationModel {
  final String id; 
  final String seekerName;
  final String seekerAvatarUrl;
  final String status; 
  final int aiMatchScore; 
  final DateTime appliedAt;

  ApplicationModel({
    required this.id,
    required this.seekerName,
    required this.seekerAvatarUrl,
    required this.status,
    required this.aiMatchScore,
    required this.appliedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    int extractedScore = 0;
    try {
      final rawScore = json['aiMatchScore'] ?? json['aiScore'] ?? json['matchScore'] ?? json['score'] ?? json['matchPercentage'];
      if (rawScore != null) {
        extractedScore = double.parse(rawScore.toString()).toInt();
      }
    } catch (e) {
      extractedScore = 0; 
    }

    return ApplicationModel(
      id: json['id']?.toString() ?? '', 
      seekerName: json['seekerName'] ?? json['name'] ?? 'user',
      seekerAvatarUrl: json['seekerAvatarUrl'] ?? json['avatarUrl'] ?? '',
      status: json['status']?.toString() ?? 'Sent', 
      aiMatchScore: extractedScore,
      appliedAt: json['appliedAt'] != null 
          ? DateTime.tryParse(json['appliedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}