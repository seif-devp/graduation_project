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

  Future<void> _pickAndUpload(BuildContext context) async {
    final cubit = context.read<ResumeCubit>();

    final result = await FilePicker.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (!context.mounted) return;

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        // ✅ بنبعت الـ jobId عشان يعمل apply بعد الـ upload
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
          return Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: primaryColor, width: 2),
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
                      SizedBox(height: 24.h),
                      if (state is ResumeLoading)
                        loading
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
              ],
            ),
          );
        },
      ),
    );
  }
}