import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ضفنا دي عشان نقرأ المسار
import 'package:graduation_project/core/widgets/employer_navigation_bar.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/Bottom_Navigation_Bar.dart';
// اعمل import للملف الجديد اللي عملناه فوق
// import 'package:graduation_project/features/.../employer_bottom_nav_bar.dart'; 

class ShellLayout extends StatelessWidget {
  final Widget child;

  const ShellLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    
    final String location = GoRouterState.of(context).uri.path;
    
    final bool isEmployerRoute = location.contains('employer');

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: child,
            ),
          );
        },
        child: child,
      ),
      bottomNavigationBar: isEmployerRoute 
          ? const EmployerBottomNavBar() 
          : const CustomBottomNavBar(),
    );
  }
}