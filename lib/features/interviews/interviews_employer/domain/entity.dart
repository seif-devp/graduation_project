class InterviewEntityEmployer {
  final String id;
  final String jobTitle;
  final String seekerName;
  final DateTime scheduledAt;
  final String status;
  final String interviewLink;
  final DateTime? rescheduleRequestedAt;

  InterviewEntityEmployer({
    required this.id,
    required this.jobTitle,
    required this.seekerName,
    required this.scheduledAt,
    required this.status,
    required this.interviewLink,
    this.rescheduleRequestedAt,
  });
}