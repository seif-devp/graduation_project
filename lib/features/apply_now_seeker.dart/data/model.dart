class ApplicationRequestModel {
  final String jobId;
  final String resumeId;
  final int aiMatchScore;

  ApplicationRequestModel({
    required this.jobId,
    required this.resumeId,
    required this.aiMatchScore,
  });

  Map<String, dynamic> toJson() {
    return {
      "jobId": jobId,
      "resumeId": resumeId,
      "aiMatchScore": aiMatchScore, // ✅ يرسل الرقم الصحيح المقرب مباشرة للسيرفر
    };
  }
}