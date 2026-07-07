import 'package:graduation_project/features/interviews/interviews_employer/domain/entity.dart';

class InterviewModelEmployer {
  final List<InterviewsEmployerModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  InterviewModelEmployer({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory InterviewModelEmployer.fromJson(Map<String, dynamic> json) =>
      InterviewModelEmployer(
        items: List<InterviewsEmployerModel>.from(
            json["items"].map((x) => InterviewsEmployerModel.fromJson(x))),
        totalCount: json["totalCount"],
        page: json["page"],
        pageSize: json["pageSize"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "totalCount": totalCount,
        "page": page,
        "pageSize": pageSize,
        "totalPages": totalPages,
      };
}

class InterviewsEmployerModel {
  final String id;
  final String applicationId;
  final String jobTitle;
  final String seekerName;
  final String employerName;
  final String companyName;
  final DateTime scheduledAt;
  final String mode;
  final String interviewLink;
  final String status;
  final DateTime? rescheduleRequestedAt;
  final DateTime createdAt;

  InterviewsEmployerModel({
    required this.id,
    required this.applicationId,
    required this.jobTitle,
    required this.seekerName,
    required this.employerName,
    required this.companyName,
    required this.scheduledAt,
    required this.mode,
    required this.interviewLink,
    required this.status,
    this.rescheduleRequestedAt,
    required this.createdAt,
  });

  factory InterviewsEmployerModel.fromJson(Map<String, dynamic> json) =>
      InterviewsEmployerModel(
        id: json["id"] ?? "",
        applicationId: json["applicationId"] ?? "",
        jobTitle: json["jobTitle"] ?? "",
        seekerName: json["seekerName"] ?? "",
        employerName: json["employerName"] ?? "",
        companyName: json["companyName"] ?? "",
        scheduledAt: json["scheduledAt"] != null
            ? DateTime.parse(json["scheduledAt"])
            : DateTime.now(),
        mode: json["mode"] ?? "",
        interviewLink: json["interviewLink"] ?? "",
        status: json["status"] ?? "",
        rescheduleRequestedAt: json["rescheduleRequestedAt"] != null
            ? DateTime.parse(json["rescheduleRequestedAt"])
            : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "applicationId": applicationId,
        "jobTitle": jobTitle,
        "seekerName": seekerName,
        "employerName": employerName,
        "companyName": companyName,
        "scheduledAt": scheduledAt.toIso8601String(),
        "mode": mode,
        "interviewLink": interviewLink,
        "status": status,
        "rescheduleRequestedAt": rescheduleRequestedAt?.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
      };

  InterviewEntityEmployer toEntity() {
    return InterviewEntityEmployer(
      id: id,
      jobTitle: jobTitle,
      seekerName: seekerName,
      scheduledAt: scheduledAt,
      status: status,
      interviewLink: interviewLink,
      rescheduleRequestedAt: rescheduleRequestedAt,
    );
  }
}
