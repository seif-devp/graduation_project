import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/resume/data/remote.dart';
import 'package:graduation_project/features/resume/data/repo.dart';
import 'package:graduation_project/features/resume/presentation/cubit/resume_cubit.dart';

class ResumeUploadScreen extends StatelessWidget {
  // ✅ بنستقبل الـ jobId
  final String? jobId;

  const ResumeUploadScreen({super.key, this.jobId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResumeCubit(ResumeRepository(ResumeRemoteDataSource())),
      child: _ResumeUploadView(jobId: jobId),
    );
  }
}

class _ResumeUploadView extends StatelessWidget {
  final String? jobId;

  const _ResumeUploadView({this.jobId});

  // دالة الـ Pick والـ Upload بيشغلها فقط زرار Apply السفلي
  Future<void> _pickAndUpload(BuildContext context) async {
    final cubit = context.read<ResumeCubit>();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (!context.mounted) return;

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        // ✅ بيبعت للموديل ويبدأ التحليل والمطابقة فوراً
        cubit.uploadResume(path, jobId: jobId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not access file. Try a different file.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Upload CV', 
          style: TextStyle(
            color: const Color.fromARGB(191, 255, 255, 255),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<ResumeCubit, ResumeState>(
        listener: (context, state) {
          if (state is ResumeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('CV uploaded & Applied successfully! ✅'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          if (state is ResumeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // داتا المهارات المفقودة بناءً على لوج الـ Render بتاعك لتعرض بشكل ديناميكي
          final List<String> missingSkillsMock = [
            "CI/CD Pipeline",
            "Firebase Analytics",
            "Cloud Deployment",
            "Unit Testing",
            "UX Principles"
          ];

          return Padding(
            padding: EdgeInsets.all(24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان المهارات المفقودة متطابق مع لوج الـ Render (Roboto, 700, 15.8)
                  Text(
                    "Missing Skills",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15.8.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  // الـ Wrap لرص الـ Chips بشكل ديناميكي ممتاز يمنع الـ Overflow
                  Wrap(
                    spacing: 8.0.w,
                    runSpacing: 8.0.h,
                    alignment: WrapAlignment.start,
                    children: missingSkillsMock.map((skill) {
                      return Chip(
                        avatar: const Icon(Icons.close, size: 16, color: Colors.red),
                        label: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Colors.red.withOpacity(0.08),
                        side: BorderSide(color: Colors.red.withOpacity(0.3)),
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // كارد التوضيح الفني (Read-Only) للعرض فقط
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: primaryColor.withOpacity(0.2), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.upload_file_outlined,
                          size: 64.sp,
                          color: primaryColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Upload Your CV',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Supported formats: PDF, DOC, DOCX',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 48.h),
                  
                  // 🟢 زرار الـ Apply الفعلي والوحيد اللي هيشغل الـ File Picker والـ Cubit
                  if (state is ResumeLoading)
                    Center(child: loading)
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _pickAndUpload(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Choose File & Apply',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}