import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/presentation/cubit/note_cubit.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/presentation/cubit/note_state.dart';
import 'package:graduation_project/features/settings/settingsSekeer/data/repoSeeker.dart';
import 'package:graduation_project/features/settings/settingsSekeer/logic/entitiy.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late Future<SeekerEntity> _userDataFuture;

  @override
  void initState() {
    super.initState();
    // بنجيب داتا اليوزر (بما فيها الصورة) أول ما الهيدر يفتح
    _userDataFuture = SettingsSekeerRepository().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔴 التعديل هنا لعرض صورة اليوزر
        FutureBuilder<SeekerEntity>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            String? avatarUrl;
            if (snapshot.hasData && snapshot.data!.avatarUrl != null && snapshot.data!.avatarUrl!.isNotEmpty) {
              avatarUrl = snapshot.data!.avatarUrl;
            }

            return CircleAvatar(
              radius: 24.r,
              backgroundColor: Colors.white,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null 
                  ? const Icon(Icons.person, color: Colors.blue) 
                  : null,
            );
          },
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Afternoon",
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              Text(
                CacheHelper.getData(key: 'name') ?? 'User',
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
          builder: (context, state) {
            int count = 0;
            if (state is NotificationSuccess) {
              count = state.notifications.where((n) => !n.isRead).length;
            }

            return IconButton(
              onPressed: () => context.push('/notifications'),
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
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}