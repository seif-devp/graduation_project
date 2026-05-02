import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployerBottomNavBar extends StatelessWidget {
  const EmployerBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;

    if (location.startsWith('/home_employer')) {
      currentIndex = 0;
    } else if (location.startsWith('/post_jobs_employer')) {
      currentIndex = 1;
    } else if (location.startsWith('/applications_swip')) {
      currentIndex = 2;
    } else if (location.startsWith('/interview_employer')) {
      currentIndex = 3;
    } else if (location.startsWith('/settings')) {
      currentIndex = 4;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.goNamed('home_employer');
            break;
          case 1:
            context.goNamed('post_jobs_employer');
            break;
          case 2:
            context.goNamed('applications_swip');
            break;
          case 3:
            context.goNamed('interview_employer');
            break;
          case 4:
            context.goNamed('settings');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), label: 'Post Jobs'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline), label: 'Applicants'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), label: 'Interviews'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
      ],
    );
  }
}
