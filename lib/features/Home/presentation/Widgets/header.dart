import 'package:flutter/material.dart';
import 'info.dart';
import 'Quick Actions.dart';

class HeaderWidget extends StatelessWidget {
  final AnimationController? collapseAnimation;

  const HeaderWidget({super.key, this.collapseAnimation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 3, 59, 122),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const UserInfo(),
          if (collapseAnimation != null)
            FadeTransition(
              opacity: Tween<double>(
                begin: 1.0,
                end: 0.0,
              ).animate(collapseAnimation!),
              child: SizeTransition(
                sizeFactor: Tween<double>(
                  begin: 1.0,
                  end: 0.0,
                ).animate(collapseAnimation!),
                axisAlignment: -1.0,
                child: QuickActions(animation: collapseAnimation),
              ),
            )
          else
            QuickActions(animation: collapseAnimation),
        ],
      ),
    );
  }
}
