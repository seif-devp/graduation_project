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
            companyLogoUrl: job.companyLogoUrl ?? '');
        context.push('/job_details', extra: jobEntity);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔴 التعديل هنا: استخدام ClipRRect مع errorBuilder لضمان عرض اللوجو بأمان
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: (job.companyLogoUrl != null &&
                          job.companyLogoUrl!.isNotEmpty &&
                          job.companyLogoUrl !=
                              "string") // بنتأكد إنه مش داتا وهمية
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            job.companyLogoUrl!.startsWith('http')
                                ? job.companyLogoUrl!
                                : 'https://smartjop.runasp.net${job.companyLogoUrl}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // لو الرابط بايظ نعرض الأيقونة الافتراضية
                              return Icon(
                                Icons.business,
                                color: Colors.blueGrey.shade400,
                                size: 26.sp,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.business,
                          color: Colors.blueGrey.shade400,
                          size: 26.sp,
                        ),
                ),
                SizedBox(width: 14.w),

                // العنوان واسم الشركة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: const Color(0xFF1A1C1E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        job.companyName,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // الموقع والمرتب
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 18.sp, color: Colors.grey.shade500),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    job.location,
                    style:
                        TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    "•",
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 16.sp),
                  ),
                ),
                Icon(Icons.monetization_on_outlined,
                    size: 18.sp, color: Colors.grey.shade500),
                SizedBox(width: 4.w),
                Text(
                  job.salary,
                  style:
                      TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
                ),
              ],
            ),

            // المتطلبات (Chips)
            if (job.requirements.isNotEmpty) ...[
              SizedBox(height: 14.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: job.requirements
                    .take(4)
                    .map((req) => _buildModernChip(req))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModernChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0052D4).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0052D4),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
