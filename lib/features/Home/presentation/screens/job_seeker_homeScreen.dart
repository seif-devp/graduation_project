import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/header.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/job_card.dart';
import 'package:graduation_project/features/Home/presentation/controller/job_Seeker_cubit.dart';
import 'package:graduation_project/features/Home/presentation/controller/job_Seeker_state.dart';

class JobSeekerHomeScreen extends StatelessWidget {
  const JobSeekerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobSeekerCubit()..loadJobs(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HeaderWidget(), 
            ),
            BlocBuilder<JobSeekerCubit, JobState>(
              builder: (context, state) {
                if (state is JobLoading) {
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                }
                if (state is JobLoaded) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: JobCard(job: state.jobs[index]),
                        );
                      },
                      childCount: state.jobs.length,
                    ),
                  );
                }
                return const SliverFillRemaining(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}