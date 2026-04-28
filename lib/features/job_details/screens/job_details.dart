import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_cubit.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/view_ai_match/presentation/screen/Ai_match.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key, required this.job});
  final JobEntity job;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobDetailsCubit()..selectJob(job),
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
        body: BlocBuilder<JobDetailsCubit, JobDetailsState>(
          builder: (context, state) {
            final job = state.job;

            if (job == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                        color: const Color(0xFF1D61FF),
                        borderRadius: BorderRadius.circular(12.r)),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.white),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text("AI Match Score 85%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1D61FF)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const AiMatch(),
                            );
                          },
                          child: const Text("View"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(job.title,
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  Text(job.company,
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
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
                  Text("Job Description",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  Text(
                    "We are looking for an experienced developer to join our team. You will work on cutting-edge applications using modern tooling and frameworks.",
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),
                  SizedBox(height: 20.h),
                  Text("Requirements",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: ["React", "TypeScript", "Node.js", "Redux"]
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
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Text("Apply Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}