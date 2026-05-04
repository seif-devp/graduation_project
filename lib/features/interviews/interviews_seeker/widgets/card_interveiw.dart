import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/domain/entity.dart';

class InterviewCard extends StatelessWidget {
  final InterviewEntity interview;
  const InterviewCard({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Title + Badge ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(interview.jobTitle,
                  style:  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Color(0xFF1A1D23))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(interview.status,
                    style: TextStyle(fontSize: 11.sp,  fontWeight: FontWeight.w600)),
              ),
            ],
          ),
           SizedBox(height: 4.h),

          Text(interview.company, style:  TextStyle(fontSize: 13.sp, color: Colors.grey)),
           SizedBox(height: 16.h),

          Row(
            children: [
               Icon(Icons.calendar_today_outlined, size: 16.sp, color: Colors.grey),
               SizedBox(width: 8.w),
              Text(interview.date, style:  TextStyle(fontSize: 13.sp, color: Color(0xFF444444))),
            ],
          ),
           SizedBox(height: 8.h),

          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
               SizedBox(width: 8.w),
              Text(interview.time, style:  TextStyle(fontSize: 13.sp, color: Color(0xFF444444))),
            ],
          ),
           SizedBox(height: 8.h),

          Row(
            children: [
              const Icon(Icons.videocam_outlined, size: 16, color: Colors.grey),
               SizedBox(width: 8.w),
              Text(interview.type, style:  TextStyle(fontSize: 13.sp, color: Color(0xFF444444))),
            ],
          ),
           SizedBox(height: 16.h),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Meeting Link', style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                 SizedBox(height: 4.h),
                Text(interview.meetingLink,
                    style:  TextStyle(fontSize: 13.sp, color: Color(0xFF3D5AFE), fontWeight: FontWeight.w500)),
              ],
            ),
          ),

        ],
      ),
    );
  }
}