import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';

class JobCardwidget extends StatefulWidget {
  const JobCardwidget({super.key, required this.job});
  final JobEntity job;

  @override
  State<JobCardwidget> createState() => _JobCardwidgetState();
}

class _JobCardwidgetState extends State<JobCardwidget> {
  bool isfavirate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: Colors.blue.shade100, width: 1.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.job.percent,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              ),

              Icon(Icons.favorite, color: Colors.red),
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            widget.job.title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),

          Text(
            widget.job.company,
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
          SizedBox(height: 20.h),

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey.shade400,
              ),
              SizedBox(width: 10.w),
              Text(
                widget.job.address,
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              Icon(Icons.attach_money, size: 18, color: Colors.grey.shade400),
              SizedBox(width: 10.w),
              Text(widget.job.salary, style: TextStyle(color: Colors.blueGrey)),
            ],
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey.shade400),
              SizedBox(width: 10.w),
              Text(widget.job.date, style: TextStyle(color: Colors.blueGrey)),
            ],
          ),
        ],
      ),
    );
  }
}
