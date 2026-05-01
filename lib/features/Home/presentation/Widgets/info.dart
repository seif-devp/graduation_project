import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Notifications/cubit/notification_cubit.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: Colors.white,
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good Afternoon",
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
              Text(
                "Sarah Johnson",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<NotificationCubit, NotificationState>(
          builder: (_, state) {
            int count = 0;
            if (state is NotificationCountLoaded) {
              count = state.unreadCount;
            }

            return IconButton(
              onPressed: () => context.go('/notifications'),
              icon: Badge(
                isLabelVisible: count > 0,
                label: Text(
                  count > 99 ? '+99' : count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 31, 8, 79),
                child: const Icon(Icons.notifications_active_outlined,
                    color: Colors.white),
              ),
            );
          },
        ),
      ],
    );
  }
}
