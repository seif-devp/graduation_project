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
      create: (context) => EmployerHomeCubit(EmployerHomeRepository(RemoteDataSourceEployer()))
        ..fetchHomeDataAndJobs(),
      child: Builder( 
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: BlocConsumer<EmployerHomeCubit, EmployerHomeState>(
              listener: (context, state) {
                if (state is DeleteJobSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حذف الوظيفة'), backgroundColor: Colors.green),
                  );
                }
              },
              builder: (context, state) {
                // إعداد بيانات افتراضية عشان الشاشة متضربش لو الداتا لسه مجتش
                final stats = state is MyJobsSuccess ? state.stats : EmployerHomeEntity(
                  activeJobs: 0, newApplicants: 0, interviewsToday: 0, interviewsCount: 0, applicantsCount: 0,
                );
                final jobs = state is MyJobsSuccess ? state.jobsList : [];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      EmployerHeaderSection(data: stats), // كدا مش هياخد Null أبداً

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                        child: const QuickActionsSection(), // تأكد من تغيير النص لـ My Jobs جوه الودجت
                      ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                              child: ListTile(
                                leading: const Icon(Icons.work_outline, color: Color(0xFF0052D4)),
                                title: Text(job.title ?? "بدون عنوان"), // استخدام . وليس []
                                subtitle: Text(job.location ?? "غير محدد"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => context.read<EmployerHomeCubit>().removeJob(job.id.toString()),
                                ),
                              ),
                            );
                          },
                        ),
                      const RecentActivitySection(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              },
            ),
          );
        }
      ),
    );
  }
}