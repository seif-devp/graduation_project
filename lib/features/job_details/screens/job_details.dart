import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_cubit.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/job_details/data/model_detail.dart';
import 'package:graduation_project/features/job_details/data/remote_detail_source.dart';
import 'package:graduation_project/features/job_details/data/repo_imp_detail.dart';
import 'package:graduation_project/features/view_ai_match/presentation/screen/Ai_match.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key, required this.jobId});
  final String jobId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobDetailsCubit(
        JobDetailsRepo(JobDetailsRemoteDataSource()),
      )..fetchJobDetails(jobId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Job Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: BlocConsumer<JobDetailsCubit, JobDetailsState>(
          listener: (context, state) {
            if (state is ApplyJobSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Applied Successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is ApplyJobError) {
              if (state.message == 'Please upload your CV first') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please upload your CV first"),
                    backgroundColor: Colors.orange,
                  ),
                );
                context.push('/resume_upload');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is JobDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is JobDetailsSuccess ||
                state is ApplyJobLoading ||
                state is ApplyJobSuccess ||
                state is ApplyJobError) {
              final job = context.read<JobDetailsCubit>().currentJob;
              if (job != null) return _buildBody(context, job, state);
            }

            if (state is JobDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, JobDetailsModel fullJob, JobDetailsState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1D61FF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(width: 10.w),
                const Expanded(
                  child: Text(
                    "AI Match Score 85%",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const AiMatch(),
                  ),
                  child: const Text("View", style: TextStyle(color: Color(0xFF1D61FF))),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            fullJob.title,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            fullJob.companyName,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              Text(" ${fullJob.location}"),
              SizedBox(width: 15.w),
              const Icon(Icons.attach_money, size: 18),
              Text(" ${fullJob.salary}"),
            ],
          ),
          SizedBox(height: 25.h),
          Text(
            "Job Description",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            fullJob.description,
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),
          SizedBox(height: 20.h),
          Text(
            "Requirements",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: fullJob.requirements
                .map((skill) => Chip(label: Text(skill)))
                .toList(),
          ),
          SizedBox(height: 40.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D61FF),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: state is ApplyJobLoading
                  ? null
                  : () => context.read<JobDetailsCubit>().applyToJob(fullJob.id),
              child: state is ApplyJobLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Apply Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}