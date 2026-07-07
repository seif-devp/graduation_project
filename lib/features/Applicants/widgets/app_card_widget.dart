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

  static const Color myPrimaryBlue = Color(0xFF033B7A);

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
          // Badge
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: myPrimaryBlue,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "$score% Match",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Avatar
          CircleAvatar(
            radius: 50.r,
            backgroundColor: myPrimaryBlue.withOpacity(0.1),
            backgroundImage: applicant.seekerAvatarUrl.isNotEmpty
                ? NetworkImage(applicant.seekerAvatarUrl)
                : null,
            child: applicant.seekerAvatarUrl.isEmpty
                ? Icon(Icons.person, color: myPrimaryBlue, size: 50.r)
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
          
          // Applied Container
          _buildInfoContainer("Applied", applicant.appliedAt.toString().split('.')[0]),
          SizedBox(height: 16.h),
          
          // Match Score Progress
          _buildMatchProgressContainer(score, progressValue),
          SizedBox(height: 24.h),
          
          // New Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCustomActionButton(
                label: "Reject",
                icon: Icons.thumb_down,
                color: const Color(0xFFFDECEA),
                iconColor: const Color(0xFFD32F2F),
                onTap: onReject,
              ),
              _buildCustomActionButton(
                label: "Interview",
                icon: Icons.calendar_month,
                color: const Color(0xFFFFF8E1),
                iconColor: const Color(0xFFFFA000),
                onTap: onInterview,
              ),
              _buildCustomActionButton(
                label: "Accept",
                icon: Icons.thumb_up,
                color: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF388E3C),
                onTap: onAccept,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500)),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildMatchProgressContainer(int score, double progress) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: const Color(0xFFF4F6FA), borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Match Score", style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500)),
          SizedBox(height: 8.h),
          Row(children: [
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(6.r), child: LinearProgressIndicator(value: progress, minHeight: 8.h, backgroundColor: Colors.grey.shade300, valueColor: const AlwaysStoppedAnimation(myPrimaryBlue)))),
            SizedBox(width: 12.w),
            Text("$score%", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.black)),
          ]),
        ],
      ),
    );
  }

  Widget _buildCustomActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}