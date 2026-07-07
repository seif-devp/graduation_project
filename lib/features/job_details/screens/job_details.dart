import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/remote_source.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/repo.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_cubit.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/job_details/data/ai_remote_source.dart';
import 'package:graduation_project/features/job_details/data/job_application_repo.dart';
import 'package:graduation_project/features/job_details/data/remote_detail_source.dart';
import 'package:graduation_project/features/job_details/data/repo_imp_detail.dart';
import 'package:graduation_project/features/job_details/screens/ai_match_dialog.dart';
import 'package:graduation_project/features/job_details/screens/resume_selection_dialog.dart';
import 'package:graduation_project/features/resume/data/model.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key, required this.jobId});
  final String jobId;

  @override
  Widget build(BuildContext context) {
  return BlocProvider(
      create: (_) => JobDetailsCubit(
        JobDetailsRepo(JobDetailsRemoteDataSource()),
        JobApplicationRepository(
          aiRemoteSource: AiMatchRemoteDataSource(),
          // التعديل هنا: بنباصي الـ Repo بدل الـ Remote Source المباشر
          dotNetRepo: ApplicationRepository(ApplicationRemoteDataSource()), 
        ),
      )..fetchJobDetails(jobId),
      child: const _JobDetailsView(),
    );
  }
}

class _JobDetailsView extends StatelessWidget {
  const _JobDetailsView();

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF1D61FF)),
            SizedBox(height: 20.h),
            Text(
              "Analyzing your CV...\nThis might take a minute ⏳",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobDetailsCubit, JobDetailsState>(
      listener: (context, state) {
        if (state is ApplyJobLoading) {
          _showLoadingOverlay(context);
        } else if (state is ApplyJobSuccess) {
          Navigator.pop(context); // إغلاق اللودينج الشفاف
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Applied Successfully! ✅"),
              backgroundColor: Colors.green,
            ),
          );
          
          showDialog(
            context: context,
            builder: (_) => AiMatchDialog(
              score: state.aiResult.matchScore,
              matchedSkills: state.aiResult.matchedSkills,
              missingSkills: state.aiResult.missingSkills,
            ),
          );
        } else if (state is ApplyJobError) {
          Navigator.pop(context); // إغلاق اللودينج
          final message = state.message;
          final isAlreadyApplied = message == 'You have already applied for this job.';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: isAlreadyApplied ? Colors.orange : Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is JobDetailsLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final cubit = context.read<JobDetailsCubit>();
        final job = cubit.currentJob;
        final hasApplied = cubit.hasApplied;

        if (job == null) return const Scaffold(body: SizedBox());

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text("Job Details", style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Column(
            children: [
              _buildAiCard(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(job.title, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                      Text(job.companyName, style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 18.sp),
                          Text(" ${job.location}", style: TextStyle(fontSize: 14.sp)),
                          SizedBox(width: 15.w),
                          Icon(Icons.attach_money, size: 18.sp),
                          Text(" ${job.salary}", style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      Text("Job Description", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      Text(job.description, style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 14.sp)),
                      SizedBox(height: 20.h),
                      Text("Requirements", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: job.requirements.map((skill) => Chip(label: Text(skill, style: TextStyle(fontSize: 12.sp)))).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasApplied ? Colors.grey : const Color(0xFF1D61FF),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    onPressed: hasApplied ? null : () async {
                      final selectedCv = await showDialog(
                        context: context,
                        builder: (context) => const ResumeSelectionDialog(),
                      );

                      if (selectedCv != null && selectedCv is ResumeModel && context.mounted) {
                        cubit.applyWithResume(selectedCv);
                      }
                    },
                    child: Text(
                      hasApplied ? "Applied ✅" : "Select CV & Apply",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAiCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1D61FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 24.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text("AI Match System Active", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
}