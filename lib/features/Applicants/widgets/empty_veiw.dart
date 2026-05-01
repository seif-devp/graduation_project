import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Text("All Done!", style: TextStyle(fontSize: 18.sp, color: Colors.grey)),
  );
}