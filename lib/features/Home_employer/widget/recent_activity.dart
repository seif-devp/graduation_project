import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
           SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _buildActivityItem(
                  icon: Icons.person_outline,
                  iconBgColor: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1976D2),
                  title: 'Sarah Jenkins applied for UX Designer',
                  time: '2 hours ago',
                ),
                Divider(height: 1, color: Colors.grey[200]),
                _buildActivityItem(
                  icon: Icons.access_time,
                  iconBgColor: const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFF57C00),
                  title: 'Interview with Mike Ross scheduled',
                  time: '5 hours ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
           SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                 SizedBox(height: 4.h),
                Text(
                  time,
                  style:  TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}