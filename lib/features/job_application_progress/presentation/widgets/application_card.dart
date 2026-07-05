import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/job_application_progress/presentation/widgets/progressTimeLine.dart';

class ApplicationCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String? logoUrl;
  final String matchPercentage;
  final String status;
  final String appliedDate;
  final VoidCallback? onTap;

  const ApplicationCard({
    super.key,
    required this.jobTitle,
    required this.companyName,
    this.logoUrl,
    required this.matchPercentage,
    required this.status,
    required this.appliedDate,
    this.onTap,
  });

  // Helper to map status string to a timeline step (0-3).
  // This logic correctly interprets seeker-side statuses.
  int _mapStatusToCurrentStep(String rawStatus) {
    final normalizedStatus = rawStatus.trim().toLowerCase();
    switch (normalizedStatus) {
      // Step 1: Application Sent
      case 'sent':
        return 0;

      // Step 2: Application Viewed by Employer
      case 'viewed':
        return 1;

      // Step 3: Interviewing Process
      // 'accepted interview' means the seeker agreed to an interview, so we are still in the interview stage.
      case 'interview':
      case 'pending':
      case 'rescheduled':
      case 'accepted interview':
        return 2;

      // Step 4: Final Decision
      // 'accepted' means the seeker has accepted the job offer.
      // 'rejected interview' is a terminal state initiated by the seeker.
      case 'decision':
      case 'hired':
      case 'accepted':
      case 'rejected':
      case 'rejected interview':
        return 3;

      default:
        return 0; // Default to the first step for any unknown status.
    }
  }

  // Helper to get the display color for a given status.
  Color _getStatusColor(String rawStatus) {
    final normalizedStatus = rawStatus.trim().toLowerCase();
    switch (normalizedStatus) {
      case 'rejected':
      case 'rejected interview':
        return Colors.red;
      case 'hired':
      case 'accepted': // Final job offer accepted
        return Colors.green;
      case 'accepted interview': // Seeker accepted the interview invitation
        return Colors.deepPurple;
      case 'interview':
      case 'pending':
      case 'rescheduled':
        return Colors.orange;
      case 'viewed':
        return Colors.grey;
      case 'sent':
      default:
        return Colors.blue;
    }
  }

  // Helper to get the display icon for a given status.
  IconData _getStatusIcon(String rawStatus) {
    final normalizedStatus = rawStatus.trim().toLowerCase();
    switch (normalizedStatus) {
      case 'rejected':
      case 'rejected interview':
        return Icons.cancel;
      case 'hired':
      case 'accepted': // Final job offer accepted
        return Icons.check_circle;
      case 'accepted interview': // Seeker accepted the interview invitation
        return Icons.event_available;
      case 'interview':
      case 'pending':
      case 'rescheduled':
        return Icons.schedule;
      case 'viewed':
        return Icons.visibility;
      case 'sent':
      default:
        return Icons.send;
    }
  }

  // Helper to set the card's background color based on terminal statuses.
  Color _getCardBackgroundColor(String rawStatus) {
    final normalizedStatus = rawStatus.trim().toLowerCase();
    switch (normalizedStatus) {
      case 'rejected':
      case 'rejected interview':
        return Colors.red.shade50; // Light red for rejection
      case 'hired':
      case 'accepted': // Light green for success
        return Colors.green.shade50;
      default:
        return Colors.white; // Default white
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _mapStatusToCurrentStep(status);
    final statusColor = _getStatusColor(status);
    final cardBackgroundColor = _getCardBackgroundColor(status);
    final statusIcon = _getStatusIcon(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(jobTitle,
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        SizedBox(height: 4.h),
                        Text(companyName,
                            style: TextStyle(
                                fontSize: 14.sp, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome,
                            size: 16, color: Color(0xFF4F46E5)),
                        SizedBox(width: 4.w),
                        Text('$matchPercentage%',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4F46E5))),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              ProgressTimeline(
                currentStep: currentStep,
                activeColor: statusColor,
              ),
              SizedBox(height: 24.h),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 20, color: statusColor),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Status: ',
                            style: TextStyle(
                                fontSize: 13.sp, color: Colors.grey[600]),
                            children: [
                              TextSpan(
                                  text: status[0].toUpperCase() +
                                      status.substring(1),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: statusColor))
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text('Applied $appliedDate',
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
