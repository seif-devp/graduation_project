import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// تأكد من مسار الموديل عندك
import 'package:graduation_project/features/resume/data/model.dart'; 

class ResumeItem extends StatelessWidget {
  final ResumeModel resume; // ✅ استقبال الموديل بالكامل
  final List<Widget> actions;

  const ResumeItem({
    super.key,
    required this.resume,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // تمييز لون الخلفية لو كانت هي السيرة الذاتية الافتراضية
        color: resume.isDefault ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        // إضافة حدود خفيفة لو كانت الافتراضية
        border: resume.isDefault ? Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)) : null,
      ),
      child: Row(
        children: [
          Icon(
            Icons.article_outlined, 
            color: resume.isDefault ? const Color(0xFF2563EB) : Colors.grey.shade600,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        resume.fileName, 
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // بادج صغير يوضح إن دي السيرة الذاتية الأساسية
                    if (resume.isDefault) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 10.sp, 
                            color: const Color(0xFF2563EB), 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(height: 4.h),
                // تنسيق التاريخ مباشرة من الموديل
                Text(
                  "Uploaded ${resume.uploadedAt.toString().split(' ')[0]}", 
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          // عرض الأيقونات المرسلة من الصفحة الأساسية
          ...actions,
        ],
      ),
    );
  }
}