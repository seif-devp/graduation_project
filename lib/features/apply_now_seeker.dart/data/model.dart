class ApplicationRequestModel {
  final String jobId;
  final String resumeId;

  ApplicationRequestModel({
    required this.jobId,
    required this.resumeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "jobId": jobId,
      "resumeId": resumeId,
    };
  }
}