class InterviewEntity {
  final String id;
  final String jobTitle;
  final String company;
  final String date;
  final String time;
  final String type;
  final String meetingLink;
  final String status;

  const InterviewEntity({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.date,
    required this.time,
    required this.type,
    required this.meetingLink,
    required this.status,
  });

  InterviewEntity copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? date,
    String? time,
    String? type,
    String? meetingLink,
    String? status,
  }) {
    return InterviewEntity(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      meetingLink: meetingLink ?? this.meetingLink,
      status: status ?? this.status,
    );
  }
}