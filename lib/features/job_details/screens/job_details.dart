import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_cubit.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/job_details/data/remote_detail_source.dart';
import 'package:graduation_project/features/job_details/data/repo_imp_detail.dart';
import 'package:graduation_project/features/view_ai_match/presentation/screen/Ai_match.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({super.key, required this.jobId});
  final String jobId;

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JobDetailsCubit(
        JobDetailsRepo(JobDetailsRemoteDataSource()),
      )..fetchJobDetails(widget.jobId),
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
                  content: Text("Applied Successfully! ✅"),
                  backgroundColor: Colors.green,
                ),
              );

              // فتح دايالوج الـ AI تلقائياً بالبيانات الحقيقية المحسوبة والمحفوظة في الكيوبيت
              final cubit = context.read<JobDetailsCubit>();
              if (cubit.matchScore != null) {
                showDialog(
                  context: context,
                  builder: (_) => AiMatch(
                    score: cubit.matchScore!,
                    matchedSkills: cubit.matchedSkills,
                    missingSkills: cubit.missingSkills,
                  ),
                );
              }
            }
            if (state is ApplyJobError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (blocContext, state) {
            if (state is JobDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final cubit = blocContext.read<JobDetailsCubit>();
            final job = cubit.currentJob;
            final hasApplied = cubit.hasApplied;

            if (job == null) return const SizedBox();

            final jobText =
                "${job.title} ${job.description} ${job.requirements.join(' ')}";

            return Column(
              children: [
                _buildAiCard(state, cubit),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.companyName,
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18),
                            Text(" ${job.location}"),
                            SizedBox(width: 15.w),
                            const Icon(Icons.attach_money, size: 18),
                            Text(" ${job.salary}"),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          "Job Description",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          job.description,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Requirements",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: job.requirements
                              .map((skill) => Chip(label: Text(skill)))
                              .toList(),
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
                        backgroundColor:
                            hasApplied ? Colors.grey : const Color(0xFF1D61FF),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: hasApplied || state is ApplyJobLoading
                          ? null
                          : () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.any,
                                allowMultiple: false,
                              );

                              if (result != null && result.files.isNotEmpty) {
                                final path = result.files.first.path;
                                if (path != null) {
                                  await CacheHelper.saveData(
                                      key: 'cvPath', value: path);

                                  if (blocContext.mounted) {
                                    blocContext
                                        .read<JobDetailsCubit>()
                                        .uploadAndSubmitApplication(
                                          jobId: widget.jobId,
                                          cvPath: path,
                                          jobDescription: jobText,
                                        );
                                  }
                                }
                              }
                            },
                      child: state is ApplyJobLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              hasApplied ? "Applied ✅" : "Upload CV & Apply",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAiCard(JobDetailsState state, JobDetailsCubit cubit) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1D61FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white),
          SizedBox(width: 10.w),
          Expanded(
            child: state is ApplyJobLoading
                ? const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Processing AI & Submitting application...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                : Text(
                    cubit.matchScore != null
                        ? "AI Match Score: ${cubit.matchScore!.toStringAsFixed(1)}%"
                        : "AI Match System Active",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
