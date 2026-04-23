import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  int _getSelectedIndex(String location) {
    switch (location) {
      case '/home':
        return 0;
      case '/jobPage':
        return 1;
      case '/interveiw':
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
        context.go('/interveiw');
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

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        _onNavigation(index, context);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xff1D4ED8),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: "Jobs"),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline),
          label: "Applied",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: "Alerts",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}
