import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';

class JobCardwidget extends StatefulWidget {
  const JobCardwidget({super.key, required this.job});
  final JobEntity job;

  @override
  State<JobCardwidget> createState() => _JobCardwidgetState();
}

class _JobCardwidgetState extends State<JobCardwidget> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push("/job_details", extra: widget.job);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.blue.shade100, width: 1.5.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    widget.job.percent,
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ),
                //
                IconButton(
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              widget.job.title,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.h),
            Text(
              widget.job.company,
              style: TextStyle(color: Colors.grey, fontSize: 18.sp),
            ),
            SizedBox(height: 20.h),
            _infoRow(Icons.location_on_outlined, widget.job.location),
            SizedBox(height: 8.h),
            _infoRow(Icons.attach_money, widget.job.salary),
            SizedBox(height: 8.h),
            _infoRow(Icons.access_time, widget.job.date),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey.shade400),
        SizedBox(width: 10.w),
        Text(text, style: const TextStyle(color: Colors.blueGrey)),
      ],
    );
  }
}
