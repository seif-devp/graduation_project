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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return const Color(0xFF3B82F6);
      case 'viewed':
        return const Color(0xFF6B7280);
      case 'interview':
        return const Color(0xFFF97316);
      case 'rejected':
        return const Color(0xFFEF4444);
      case 'accepted':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return Icons.send;
      case 'viewed':
        return Icons.visibility;
      case 'interview':
        return Icons.calendar_today;
      case 'rejected':
        return Icons.close;
      case 'accepted':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  Color colorCard(String status) {
    final s = status.toLowerCase();
    if (s == 'rejected') return const Color(0xFFFFEBEE);
    if (s == 'accepted') return const Color(0xFFE8F5E9);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorCard(status),
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
              buildProgressTimeline(status, _getStatusColor(status)),
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
                    Icon(_getStatusIcon(status),
                        size: 20, color: _getStatusColor(status)),
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B)))
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
