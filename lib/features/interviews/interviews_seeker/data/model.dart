import 'package:intl/intl.dart'; // Add intl to pubspec.yaml for date formatting
import 'package:graduation_project/features/interviews/interviews_seeker/domain/entity.dart';

class InterviewModel extends InterviewEntity {
  const InterviewModel({
    required super.id,
    required super.jobTitle,
    required super.company,
    required super.date,
    required super.time,
    required super.mode,
    required super.meetingLink,
    required super.status,
    super.rescheduleRequestedAt,
  });

  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    // Parse the ISO date string from the API
    DateTime mainDate;
    if (json['rescheduleRequestedAt'] != null) {
      mainDate = DateTime.parse(json['rescheduleRequestedAt']);
    } else {
      mainDate =
          DateTime.parse(json['scheduledAt'] ?? DateTime.now().toString());
    }

    return InterviewModel(
      id: json['id'] ?? '',
      jobTitle: json['jobTitle'] ?? 'No Title',
      company: json['companyName'] ?? 'Unknown Company',
      // Format the DateTime into the strings your UI expects
      date: DateFormat('MMM dd, yyyy').format(mainDate), // e.g., May 11, 2026
      time: DateFormat('hh:mm a').format(mainDate), // e.g., 03:29 PM
      mode: json['mode'] ?? 'Online',
      meetingLink: json['interviewLink'] ?? 'No link provided',
      status: json['status'] ?? 'Pending',
      rescheduleRequestedAt: json['rescheduleRequestedAt'],
    );
  }
}
