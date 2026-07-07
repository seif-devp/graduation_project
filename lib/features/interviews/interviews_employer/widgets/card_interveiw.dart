import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/interviews/interviews_employer/domain/entity.dart';
import 'package:intl/intl.dart';

class InterviewCardEmployer extends StatelessWidget {
  final InterviewEntityEmployer interviewemployer;
  const InterviewCardEmployer({
    super.key,
    required this.interviewemployer,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'confirmed':
      case 'completed':
        return const Color(0xFF22C55E);
      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return const Color(0xFFEF4444);
      case 'pending':
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Widget _iconBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(interviewemployer.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + Subtitle + Badge ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(interviewemployer.jobTitle,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1D23))),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(interviewemployer.status,
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor)),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Row(
            children: [
              _iconBadge(Icons.calendar_today_outlined, const Color(0xFF3B82F6)),
              SizedBox(width: 10.w),
              Text(DateFormat.yMMMd().format(interviewemployer.scheduledAt),
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF444444))),
            ],
          ),
          SizedBox(height: 10.h),

          Row(
            children: [
              _iconBadge(Icons.access_time, const Color(0xFFF59E0B)),
              SizedBox(width: 10.w),
              Text(DateFormat.jm().format(interviewemployer.scheduledAt),
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF444444))),
            ],
          ),
          SizedBox(height: 10.h),

          Row(
            children: [
              _iconBadge(Icons.videocam_outlined, const Color(0xFFA855F7)),
              SizedBox(width: 10.w),
              const Text('Online',
                  style: TextStyle(fontSize: 13, color: Color(0xFF444444))),
            ],
          ),
          SizedBox(height: 16.h),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.link, size: 16, color: Color(0xFF3D5AFE)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(interviewemployer.interviewLink,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF3D5AFE),
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}