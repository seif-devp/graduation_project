import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Notifications/cubit/notification_cubit.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good Afternoon", style: TextStyle(color: Colors.white70)),
              Text(
                "Sarah Johnson",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width:100),
          IconButton(
            onPressed: () {},
            icon: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (_, state) {
                int count = 5;

                if (state is NotificationCountLoaded) {
                  count = state.unreadCount;
                }

                return Badge(
                  isLabelVisible: count > 0,

                  // عرض الرقم مع هندلة الأرقام اللي أكبر من 99
                  label: Text(
                    count > 99 ? '+99' : count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  backgroundColor: const Color.fromARGB(255, 31, 8, 79),
                  child: const Icon(Icons.notifications_active_outlined,color: Colors.white,),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
