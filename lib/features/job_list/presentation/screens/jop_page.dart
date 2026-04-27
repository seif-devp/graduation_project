import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/widgets/job_card.dart';
import 'package:graduation_project/features/job_list/data/job_repo_imp.dart';
import 'package:graduation_project/features/job_list/domain/job_use_case.dart';
import 'package:graduation_project/features/job_list/presentation/cubit/job_list_cubit.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobListCubit(JobUseCase(JobRepoImp()))..fetchJob(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Discover Jobs", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.sp)),
              Text("AI-matched positions for you", style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp)),
            ],
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.tune, color: Colors.blue.shade700),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    
                          TextField(
                            decoration: const InputDecoration(labelText: "Search by title", prefixIcon: Icon(Icons.search)),
                            onChanged: (val) => context.read<JobListCubit>().filterJobs(title: val),
                          ),
                           SizedBox(height: 20.h),
                          const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 10,
                            children: ["San Francisco, CA", "New York, NY"].map((loc) => FilterChip(
                              label: Text(loc),
                              onSelected: (val) {
                                context.read<JobListCubit>().filterJobs(location: val ? loc : null);
                                Navigator.pop(ctx);
                              },
                            )).toList(),
                          ),
                           SizedBox(height: 20.h),
                          const Text("Salary Range", style: TextStyle(fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 10,
                            children: ["\$120k - \$110k", "\$120k - \$180k"].map((sal) => FilterChip(
                              label: Text(sal),
                              onSelected: (val) {
                                context.read<JobListCubit>().filterJobs(salary: val ? sal : null);
                                Navigator.pop(ctx);
                              },
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
             SizedBox(width: 8.w),
          ],
        ),
        body: BlocBuilder<JobListCubit, JobListState>(
          builder: (context, state) {
            if (state is JobListLoading) return const Center(child: CircularProgressIndicator());
            if (state is JobListSuccess) {
              // 2. ListView.builder يجعل الكارت يأخذ عرض الشاشة كاملاً تلقائياً
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
            if (state is JobListFailure) return Center(child: Text(state.massege));
            return const SizedBox();
          },
        ),
      ),
    );
  }
}