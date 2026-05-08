import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/model_response.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';

class JobCard extends StatelessWidget {
  final JobModel job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final jobEntity = JobEntity(
          title: job.title,
          companyName: job.companyName, 
          location: job.location,
          salary: job.salary, 
          id: job.id, 
          type: job.type, 
          companyLogoUrl: ''
        );
        context.push('/job_details', extra: jobEntity);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff1D4ED8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.auto_awesome_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      Text(
                        "95%", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              job.companyName, 
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 5.w),
                Text(job.location, style: TextStyle(fontSize: 14.sp)),
                SizedBox(width: 10.w),
                Text(job.salary, style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: job.requirements.take(4).map((req) => chip(req)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget chip(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text, 
      style: TextStyle(fontSize: 13.sp),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}