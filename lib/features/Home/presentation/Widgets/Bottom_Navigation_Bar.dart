import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Notifications/cubit/notification_cubit.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  int _getSelectedIndex(String location) {
    switch (location) {
      case '/home':
        return 0;
      case '/jobPage':
        return 1;
      case '/applying':
        return 2;
      case '/alerts':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  void _onNavigation(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/jobPage');
        break;
      case 2:
        context.go('/applying');
        break;
      case 3:
        context.go('/alerts');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int currentIndex = _getSelectedIndex(location);

    return BlocProvider(
      create: (context) => NotificationCubit(),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          _onNavigation(index, context);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff1D4ED8),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 10,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "Applied",
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                int count = 5;

                if (state is NotificationCountLoaded) {
                  count = state.unreadCount;
                }

                return Badge(
                  // النقطة هتختفي تماماً لو العداد صفر
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

                  backgroundColor: Colors.red,
                  child: const Icon(Icons.notifications_outlined),
                );
              },
            ),
            activeIcon: const Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
