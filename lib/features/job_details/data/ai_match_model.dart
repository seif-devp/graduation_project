class AiMatchModel {
  final double matchScore;
  final String result;
  final List<String> matchedSkills;
  final List<String> missingSkills;

  AiMatchModel({
    required this.matchScore,
    required this.result,
    required this.matchedSkills,
    required this.missingSkills,
  });

  factory AiMatchModel.fromJson(Map<String, dynamic> json) {
    return AiMatchModel(
      matchScore: (json['match_score'] as num?)?.toDouble() ?? 0.0,
      result: json['result'] ?? '',
      matchedSkills: List<String>.from(json['matched_skills'] ?? []),
      missingSkills: List<String>.from(json['missing_skills'] ?? []),
    );
  }
}