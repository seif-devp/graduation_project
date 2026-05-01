import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Applicants/logic/entity.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_cubit.dart';


class ApplicantCard extends StatelessWidget {
  final ApplicantEntity applicant;

  const ApplicantCard({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {

    return Transform.rotate(
      angle: 0.0, 
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(color: const Color(0xFF1E40AF), borderRadius: BorderRadius.circular(10.r)),
                child: Text('${applicant.matchScore}% Match', style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            
            SizedBox(height: 10.h),
            CircleAvatar(radius: 40.r, backgroundColor: Colors.blue.shade50, child: Icon(Icons.person, size: 40.sp, color: Colors.blue.shade200)),
            SizedBox(height: 12.h),
            Text(applicant.name, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            Text('${applicant.experience} years experience', style: TextStyle(color: Colors.grey, fontSize: 13.sp)),

            SizedBox(height: 20.h), 

            _buildInfoBox('Applied', applicant.appliedDate),
            SizedBox(height: 10.h),
            _buildScoreBox('Match Score', applicant.matchScore),

            SizedBox(height: 25.h), 

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleButton(Icons.thumb_down_alt_outlined, Colors.red, () => context.read<ApplicantsCubit>().swipeLeft()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12.r)),
                  child: Row(children: [Icon(Icons.calendar_month_outlined, size: 18.sp), SizedBox(width: 6.w), Text('Interview', style: TextStyle(fontSize: 13.sp))],),
                ),
                _buildCircleButton(Icons.thumb_up_alt_outlined, Colors.green, () => context.read<ApplicantsCubit>().swipeRight()),
              ],
            ),
            SizedBox(height: 15.h),
            Text('Swipe left to reject • Swipe right to shortlist', style: TextStyle(color: Colors.grey, fontSize: 10.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 10.sp)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ]),
    );
  }

  Widget _buildScoreBox(String title, int score) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 10.sp)),
        SizedBox(height: 6.h),
        Row(children: [
          Expanded(child: LinearProgressIndicator(value: score/100, minHeight: 6.h, backgroundColor: Colors.grey.shade300, valueColor: const AlwaysStoppedAnimation(Color(0xFF1E40AF)))),
          SizedBox(width: 10.w),
          Text('$score%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
        ]),
      ]),
    );
  }

  Widget _buildCircleButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12.r)), child: Icon(icon, color: Colors.white, size: 22.sp)));
  }
}