import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Frame extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;

  const Frame({super.key, required this.title, this.icon, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                if (icon != null) Icon(icon, color: const Color(0xFF2563EB)),
                 SizedBox(width: 8.w),
                Text(title, style:  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
           SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }
}