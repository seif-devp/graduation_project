// lib/features/job_list/presentation/pages/job_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/widgets/job_card.dart';
import 'package:graduation_project/features/job_list/data/job_repo_imp.dart';
import 'package:graduation_project/features/job_list/data/remote_data_source.dart';

import 'package:graduation_project/features/job_list/presentation/cubit/job_list_cubit.dart';
import 'package:graduation_project/features/job_list/presentation/cubit/job_list_state.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // الربط الصحيح بالـ UseCase والـ Repository
      create: (context) => JobSeekerCubit((JobSeekerRepositoryImpl(JobsRemoteDataSource())))..fetchJobs(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Discover Jobs",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp)),
              Text("AI-matched positions for you",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp)),
            ],
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.tune, color: Colors.blue.shade700),
                onPressed: () => _showFilterSheet(context),
              );
            }),
            SizedBox(width: 8.w),
          ],
        ),
        body: BlocBuilder<JobSeekerCubit, JobSeekerState>(
          builder: (context, state) {
            if (state is GetJobsLoading) {
              return const Center(child: CircularProgressIndicator()); // اتأكد ان Loading widget متعرفة عندك
            }
            if (state is GetJobsSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.jobs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: JobCardwidget(job: state.jobs[index]),
                  );
                },
              );
            }
            if (state is GetJobsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Search by title",
                  prefixIcon: Icon(Icons.search)),
              onChanged: (val) => context.read<JobSeekerCubit>().filterJobs(title: val),
            ),
            SizedBox(height: 20.h),
            const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 10,
              children: ["San Francisco, CA", "New York", "Cairo"]
                  .map((loc) => FilterChip(
                        label: Text(loc),
                        onSelected: (selected) {
                          context.read<JobSeekerCubit>().filterJobs(location: selected ? loc : "");
                          Navigator.pop(ctx);
                        },
                      )).toList(),
            ),
            SizedBox(height: 20.h),
            const Text("Salary Range", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 10,
              children: ["\$120k - \$150k", "\$150k - \$180k"]
                  .map((sal) => FilterChip(
                        label: Text(sal),
                        onSelected: (selected) {
                          context.read<JobSeekerCubit>().filterJobs(salary: selected ? sal : "");
                          Navigator.pop(ctx);
                        },
                      )).toList(),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}