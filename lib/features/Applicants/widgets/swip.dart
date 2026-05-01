import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwipeIndicator extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Alignment alignment;
  const SwipeIndicator({super.key, required this.icon, required this.color, required this.alignment});
  @override
  Widget build(BuildContext context) => Container(
        alignment: alignment,
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(24.r)),
        child: Icon(icon, color: color, size: 50.sp),
      );
}
