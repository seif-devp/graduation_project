import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/features/Home/Home_employer/logic/entity.dart';
import 'package:graduation_project/features/Notifications/notification_employer/cubit/notification_Employer_cubit.dart';

class EmployerHeaderSection extends StatelessWidget {
  final EmployerHomeEntity data;

  const EmployerHeaderSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String rawName = CacheHelper.getData(key: 'name') ?? 'Employer';
    String formattedName = rawName.isNotEmpty
        ? '${rawName[0].toUpperCase()}${rawName.substring(1)}'
        : 'Employer';

    return Container(
      padding:
          EdgeInsets.only(top: 60.h, left: 20.w, right: 20.w, bottom: 30.h),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Good morning,',
                      style: TextStyle(color: Colors.white70)),
                  Text(formattedName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold)),
                ],
              ),

              // --- التصحيح هنا: استخدام blocBuilder للتحقق من نوع الحالة ---
              BlocBuilder<NotificationCubitEmployer, NotificationStateEmployer>(
                builder: (context, state) {
                  int unreadCount = 0;
                  if (state is NotificationCountLoaded) {
                    unreadCount = state.unreadCount;
                  }

                  return Badge(
                    isLabelVisible: unreadCount > 0,
                    label: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: const Color.fromARGB(255, 28, 4, 68),
                    offset: const Offset(-4, 4),
                    child: IconButton(
                      onPressed: () {
                        context.goNamed('notificationsEmployer');
                      },
                      icon: Icon(Icons.notifications_none,
                          color: Colors.white, size: 28.sp),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                    'ACTIVE JOBS', '${data.activeJobs}', Icons.work_outline),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStatCard(
                  'APPLICANTS',
                  '${data.newApplicants}',
                  Icons.people_outline,
                  trendText: '+3 this week',
                  isPositiveTrend: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildWideStatCard('INTERVIEWS TODAY', '${data.interviewsToday}',
              Icons.calendar_today_outlined),
        ],
      ),
    );
  }

  // --- باقي الودجتس ثابتة بدون تغيير ---
  Widget _buildStatCard(String title, String count, IconData icon,
      {String? trendText, bool isPositiveTrend = true}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: Colors.grey),
              SizedBox(width: 8.w),
              Text(title,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]))
            ],
          ),
          SizedBox(height: 12.h),
          Text(count,
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1C1E))),
          if (trendText != null) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      color: (isPositiveTrend ? Colors.green : Colors.red)
                          .withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: Icon(
                      isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                      color: isPositiveTrend ? Colors.green : Colors.red,
                      size: 14.sp),
                ),
                SizedBox(width: 6.w),
                Text(trendText,
                    style: TextStyle(
                        color: isPositiveTrend ? Colors.green : Colors.red,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWideStatCard(String title, String count, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, size: 16.sp, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(title,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp))
              ]),
              SizedBox(height: 8.h),
              Text(count,
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1C1E))),
            ],
          ),
          Text('View Calendar >',
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp)),
        ],
      ),
    );
  }
}
