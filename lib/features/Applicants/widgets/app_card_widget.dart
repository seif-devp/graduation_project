import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Applicants/data/model_view_data.dart';

class ApplicantCard extends StatelessWidget {
  final ApplicationModel applicant;
  final VoidCallback? onReject;
  final VoidCallback? onAccept;
  final VoidCallback? onInterview;

  const ApplicantCard({
    super.key,
    required this.applicant,
    this.onReject,
    this.onAccept,
    this.onInterview,
  });

  @override
  Widget build(BuildContext context) {
    final int score = applicant.aiMatchScore;
    final double progressValue = score / 100.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1D61FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "${applicant.aiMatchScore}% Match",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          CircleAvatar(
            radius: 50.r,
            backgroundColor: const Color(0xFFE3F2FD),
            backgroundImage: applicant.seekerAvatarUrl.isNotEmpty
                ? NetworkImage(applicant.seekerAvatarUrl)
                : null,
            child: applicant.seekerAvatarUrl.isEmpty
                ? Icon(Icons.person, color: const Color(0xFF1D61FF), size: 50.r)
                : null,
          ),
          SizedBox(height: 12.h),
          Text(
            applicant.seekerName,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FA),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Applied",
                  style:
                      TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
                ),
                SizedBox(height: 4.h),
                Text(
                  applicant.appliedAt.toString().split('.')[0],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FA),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Match Score",
                  style:
                      TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 8.h,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF1D61FF)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "$score%",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                ///////// on accepet
                onTap: onAccept,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF388E3C),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(Icons.thumb_up, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: onInterview,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: Colors.black, size: 18),
                      SizedBox(width: 6.w),
                      Text(
                        "Interview",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: onReject,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(Icons.thumb_down, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
