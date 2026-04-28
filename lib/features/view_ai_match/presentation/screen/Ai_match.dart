import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiMatch extends StatelessWidget {
  const AiMatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(20.w),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("AI Match Analysis", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(Icons.close, size: 18.sp, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                
                      SizedBox(
                        width: 85.w,
                        height: 85.w,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 6.w,
                          color: Colors.blue.withOpacity(0.1),
                        ),
                      ),
                      
                      SizedBox(
                        width: 85.w,
                        height: 85.w,
                        child: CircularProgressIndicator(
                          value: 0.85,
                          strokeWidth: 6.w,
                          color: Colors.blue,
                          backgroundColor: Colors.transparent,
                        ),
                      ),

                      Text("85%", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text("Match Score", style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 20.sp),
                SizedBox(width: 8.w),
                Text("Why You Match", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10.h),
            Text("•  5+ years of React experience", style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700)),
            SizedBox(height: 4.h),
            Text("•  Strong TypeScript proficiency", style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700)),
            SizedBox(height: 4.h),
            Text("•  Previous work on enterprise applications", style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700)),
            SizedBox(height: 20.h),

            Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 20.sp),
                SizedBox(width: 8.w),
                Text("Matching Skills", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
                  child: Text("React", style: TextStyle(color: Colors.green, fontSize: 12.sp)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
                  child: Text("TypeScript", style: TextStyle(color: Colors.green, fontSize: 12.sp)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
                  child: Text("Node.js", style: TextStyle(color: Colors.green, fontSize: 12.sp)),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 5. قسم Missing Skills
            Row(
              children: [
                Icon(Icons.highlight_off, color: Colors.deepOrange, size: 20.sp),
                SizedBox(width: 8.w),
                Text("Missing Skills", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
                  child: Text("GraphQL", style: TextStyle(color: Colors.deepOrange, fontSize: 12.sp)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
                  child: Text("Redux", style: TextStyle(color: Colors.deepOrange, fontSize: 12.sp)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}