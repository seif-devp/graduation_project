import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressTimeline extends StatelessWidget {
  final int currentStep; // 0-indexed: 0=Sent, 1=Viewed, 2=Interview, 3=Decision
  final Color activeColor;

  const ProgressTimeline({
    super.key,
    required this.currentStep,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final stages = ['Sent', 'Viewed', 'Interview', 'Decision'];
    final inactiveColor = Colors.grey.shade300;
    final inactiveTextColor = Colors.grey.shade500;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stages.length, (index) {
        final isActive = index <= currentStep;
        final lineColor = isActive ? activeColor : inactiveColor;
        final nodeColor = isActive ? activeColor : inactiveColor;
        final textColor =
            isActive ? const Color(0xFF1E293B) : inactiveTextColor;

        return Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 36.h,
                child: Row(
                  children: [
                    // Left connecting line
                    Expanded(
                      child: Container(
                        height: 3.h,
                        color: index == 0 ? Colors.transparent : lineColor,
                      ),
                    ),
                    // Node (circle)
                    Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: nodeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: (index < currentStep ||
                                (index == 3 && currentStep == 3))
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : (isActive && index == currentStep && index != 3)
                                ? Icon(Icons.circle,
                                    size: 12,
                                    color: Colors.white.withOpacity(0.8))
                                : Container(
                                    width: 8.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                      ),
                    ),
                    // Right connecting line
                    Expanded(
                      child: Container(
                        height: 3.h,
                        color: index == stages.length - 1
                            ? Colors.transparent
                            : (index < currentStep
                                ? activeColor
                                : inactiveColor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                stages[index],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}
