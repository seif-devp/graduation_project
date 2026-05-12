import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Home/Home_employer/data/remote_data_source_eployer.dart';
import 'package:graduation_project/features/Home/Home_employer/data/repo_imp.dart';
import 'package:graduation_project/features/Home/Home_employer/logic/entity.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/cubit/home_employer_cubit.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/cubit/home_employer_state.dart';
import 'package:graduation_project/features/Home/Home_employer/widget/employer_header.dart';
import 'package:graduation_project/features/Home/Home_employer/widget/quick_actions.dart';
import 'package:graduation_project/features/Home/Home_employer/widget/recent_activity.dart';

class EmployerHomeScreen extends StatelessWidget {
  const EmployerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EmployerHomeCubit(EmployerHomeRepository(RemoteDataSourceEployer()))
            ..fetchHomeDataAndJobs(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: BlocConsumer<EmployerHomeCubit, EmployerHomeState>(
            listener: (context, state) {
              if (state is DeleteJobSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('تم حذف الوظيفة'),
                      backgroundColor: Colors.green),
                );
              }
            },
            builder: (context, state) {
              final stats = state is MyJobsSuccess
                  ? state.stats
                  : EmployerHomeEntity(
                      activeJobs: 0,
                      newApplicants: 0,
                      interviewsToday: 0,
                      interviewsCount: 0,
                      applicantsCount: 0,
                    );

              final allJobs = state is MyJobsSuccess ? state.jobsList : [];
              final recentJobs = allJobs.take(3).toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EmployerHeaderSection(data: stats),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 24.h),
                      child: const QuickActionsSection(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    recentJobs.isEmpty
                        ? const RecentActivitySection()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: recentJobs.length,
                            itemBuilder: (context, index) {
                              final job = recentJobs[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r)),
                                elevation: 0.5,
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0052D4)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: const Icon(Icons.work_outline,
                                        color: Color(0xFF0052D4)),
                                  ),
                                  title: Text(job.title ?? "بدون عنوان",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(job.companyName ?? "غير محدد"),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () => context
                                        .read<EmployerHomeCubit>()
                                        .removeJob(job.id.toString()),
                                  ),
                                ),
                              );
                            },
                          ),
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}