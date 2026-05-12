import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/domain/entity.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/presentation/cubit/interview_cubit.dart';

class InterviewCard extends StatelessWidget {
  final InterviewEntity interview;
  const InterviewCard({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {
    bool isPending = interview.status.toLowerCase() == 'pending';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h), // مسافة بين الكروت
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      // ── الحل هنا: IntrinsicHeight بيخلي الـ Row يعرف أطول طفل فيه ويخلي الباقي زيه ──
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── الجزء الشمال: بيانات المقابلة ──
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          interview.jobTitle,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        _buildStatusBadge(interview.status),
                      ],
                    ),
                    Text(interview.company,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                    SizedBox(height: 16.h),
                    _buildInfoRow(
                        Icons.calendar_today, Colors.blue, interview.date),
                    SizedBox(height: 8.h),
                    _buildInfoRow(
                        Icons.access_time, Colors.orange, interview.time),
                    SizedBox(height: 8.h),
                    _buildInfoRow(
                        Icons.videocam_outlined, Colors.purple, interview.type),
                    SizedBox(height: 12.h),
                    _buildMeetingLink(interview.meetingLink),
                  ],
                ),
              ),
            ),

            // ── الجزء اليمين: أيقونات التحكم الرأسية ──
            if (isPending)
              Container(
                width: 50.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionIconButton(
                      icon: Icons.check_circle_outline,
                      color: Colors.green,
                      onTap: () => context
                          .read<InterviewCubit>()
                          .handleInterviewAction(interview.id, 'accept'),
                    ),
                    _buildActionIconButton(
                      icon: Icons.cancel_outlined,
                      color: Colors.red,
                      onTap: () => context
                          .read<InterviewCubit>()
                          .handleInterviewAction(interview.id, 'reject'),
                    ),
                    _buildActionIconButton(
                      icon: Icons.history_outlined,
                      color: Colors.blueAccent,
                      onTap: () {
                        // هنا تفتح الـ Date Picker
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ميثود أيقونة الأكشن بشكل أنظف
  Widget _buildActionIconButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 24.sp),
      splashRadius: 20.w,
    );
  }

  // ميثود البيانات (التاريخ، الوقت...) مع النقط الملونة
  Widget _buildInfoRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Container(
          width: 22.w,
          height: 22.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 12.sp, color: color),
        ),
        SizedBox(width: 10.w),
        Text(
          text,
          style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isPending = status.toLowerCase() == 'pending';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPending
            ? Colors.orange.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 10.sp,
            color: isPending ? Colors.orange : Colors.green,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMeetingLink(String link) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.link, size: 14.sp, color: Colors.blue),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              link,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.blue,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}
