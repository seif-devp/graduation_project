import 'package:flutter/material.dart';

Widget buildProgressTimeline(String status) {
   final stages = ['Sent', 'Viewed', 'Interview', 'Decision'];
    final statusLower = status.toLowerCase();
    final currentIndex = stages.indexWhere((s) => s.toLowerCase() == statusLower);

    final activeColor = const Color(0xFFF97316); 
    final inactiveColor = const Color(0xFFF1F5F9); 

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        stages.length,
        (index) {
          final isCompleted = index < currentIndex && currentIndex != -1;
          final isCurrent = index == currentIndex;
          final isUpcoming = index > currentIndex;

          return Expanded(
            child: Column(
              children: [
                // الحل هنا: ثبتنا الارتفاع بـ 36 عشان الخطوط كلها تلحم في نفس المستوى السنتر
                SizedBox(
                  height: 36, 
                  child: Row(
                    children: [
                      // الخط الأيسر 
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index == 0
                              ? Colors.transparent 
                              : (index <= currentIndex ? activeColor : inactiveColor),
                        ),
                      ),
                      // الدائرة (Node)
                      Container(
                        width: isCurrent ? 36 : 28, 
                        height: isCurrent ? 36 : 28,
                        decoration: BoxDecoration(
                          color: isUpcoming ? inactiveColor : activeColor,
                          shape: BoxShape.circle,
                        ),
                        child: isCompleted
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : isUpcoming
                                ? Center(
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF94A3B8), 
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null, 
                      ),
                      // الخط الأيمن 
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index == stages.length - 1
                              ? Colors.transparent
                              : (index < currentIndex ? activeColor : inactiveColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stages[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isUpcoming ? Colors.grey[500] : const Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }