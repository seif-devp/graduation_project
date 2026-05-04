import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Notifications/notification_employer/cubit/notification_Employer_cubit.dart';
// NotificationCard will be used when notifications backend is integrated.

class NotificationsPageEmployer extends StatelessWidget {
  const NotificationsPageEmployer({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationCubitEmployer>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('New job matches & updates',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          BlocBuilder<NotificationCubitEmployer, NotificationStateEmployer>(
            builder: (_, state) {
              if (state is NotificationCountLoaded && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    cubit.makeallread();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Marked all as read')));
                  },
                  child: const Text('Mark all read'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubitEmployer, NotificationStateEmployer>(
        builder: (_, state) {
          int count = 0;
          if (state is NotificationCountLoaded) count = state.unreadCount;

          if (count == 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.notifications_none,
                          size: 36, color: Colors.blue.shade400),
                    ),
                    const SizedBox(height: 20),
                    const Text('All Caught Up!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const SizedBox(
                      width: 300,
                      child: Text(
                        "You don't have any new alerts at the moment. We'll notify you when new opportunities arrive.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // No concrete notifications available yet. Integrate notifications
          // repository to render real items here.
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.notifications_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No notifications data',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    "Notifications will appear here once the backend is connected.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
