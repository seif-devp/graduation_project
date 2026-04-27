import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActions extends StatelessWidget {
  final AnimationController? animation;

  const QuickActions({super.key, this.animation});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.search,
        'label': 'Search Jobs',
        'color': const Color(0xFF4A90E2),
        'route': 'jobPage',
      },
      {
        'icon': Icons.upload_file,
        'label': 'Upload CV',
        'color': const Color(0xFFB366FF),
        'route': 'profile',
      },
      {
        'icon': Icons.favorite,
        'label': 'Favorites',
        'color': const Color(0xFFE91E63),
        'route': null,
      },
      {
        'icon': Icons.calendar_today,
        'label': 'Interviews',
        'color': const Color(0xFFFF9800),
        'route': 'interview',
      },
    ];

    if (animation == null) {
      return _buildGrid(actions, context);
    }

    return AnimatedBuilder(
      animation: animation!,
      builder: (context, child) {
        // Simply fade out the grid, no icon preview
        final double opacity = (1 - animation!.value).clamp(0, 1);
        return Opacity(opacity: opacity, child: _buildGrid(actions, context));
      },
    );
  }

  // Compact 2x2 Grid with smaller icons and labels
  Widget _buildGrid(List<Map<String, dynamic>> actions, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4, // Slightly more compact
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(actions.length, (index) {
          final action = actions[index];
          return GestureDetector(
            onTap: () {
              if (action['route'] != null) {
                context.pushNamed(action['route']);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 3, 59, 122),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10), // Reduced from 14
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (action['color'] as Color).withOpacity(0.8),
                          (action['color'] as Color).withOpacity(0.2),
                        ],
                      ),
                      border: Border.all(
                        color: (action['color'] as Color).withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: Colors.white,
                      size: 24, // Reduced from 32
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced from 12
                  Text(
                    action['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13, // Reduced from 14
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
