import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});
  @override
  Widget build(BuildContext context) {

    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [

      stat("12", "Applications"),
      stat("3", "Interviews"),
      stat("8", "Saved Jobs"),
    ],
  );
  } 
}
 Widget stat(String n, String t) => Column(
    children: [
      Text(
        n,
        style:  TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2563EB),
        ),
      ),
      Text(t, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
