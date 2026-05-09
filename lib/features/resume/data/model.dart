class ResumeModel {
  final String id;
  final String fileName;
  final String fileUrl;
  final bool isDefault;
  final DateTime uploadedAt;

  ResumeModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.isDefault,
    required this.uploadedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] ?? '',
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      isDefault: json['isDefault'] ?? false,
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }
}