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
               Text(
                "Discover Jobs",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
              ),
              Text(
                "AI-matched positions for you",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            
            Builder( // استخدمنا Builder عشان نقدر نوصل للـ context بتاع الكيوبت
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.tune, color: Colors.blue.shade700),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (bottomSheetContext) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text("Test Filters", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              
                              ElevatedButton(
                                onPressed: () {
                                  context.read<JobListCubit>().filterByLocation("San Francisco");
                                  Navigator.pop(context);
                                },
                                child: const Text("Show San Francisco Jobs"),
                              ),
                              const SizedBox(height: 10),

                              // زرار الغاء الفلتر
                              OutlinedButton(
                                onPressed: () {
                                  context.read<JobListCubit>().filterByLocation("");
                                  Navigator.pop(context);
                                },
                                child: const Text("Clear Filters"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }
            ),
            const SizedBox(width: 8),
          ],
        ),

        body: BlocBuilder<JobListCubit, JobListState>(
          builder: (context, state) {
            if (state is JobListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JobListSuccess) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(state.jobs.length, (index) {
                    return JobCardwidget(job: state.jobs[index]);
                  }),
                ),
              );
            } else if (state is JobListFailure) {
              return Center(child: Text(state.massege));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
