import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/Bottom_Navigation_Bar.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/Suggested.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/header.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/job_card.dart';
import 'package:graduation_project/features/Home/presentation/controller/job_Seeker_cubit.dart';
import 'package:graduation_project/features/Home/presentation/controller/job_Seeker_state.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  const JobSeekerHomeScreen({super.key});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen> {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobSeekerCubit()..loadJobs(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],

        body: Column(
          children: [
            HeaderWidget(),
            BlocBuilder<JobSeekerCubit, JobState>(
              builder: (context, state) {
                if (state is JobLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is JobLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: state.jobs.length,
                      itemBuilder: (context, index) {
                        final job = state.jobs[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0) ...[
                              SectionTitle(),
                              SizedBox(height: 12),
                            ],

                            JobCard(job: job),
                          ],
                        );
                      },
                    ),
                  );
                }

                if (state is JobError) {
                  return Center(child: Text(state.message));
                }

                return SizedBox();
              },
            ),
            CustomBottomNavBar(),
          ],
        ),
      ),
    );
  }
}
