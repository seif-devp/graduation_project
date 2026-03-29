import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/presentation/controller/cubit.dart';
import 'package:graduation_project/features/Home/presentation/controller/state.dart';

import '../Widgets/Suggested.dart';
import '../Widgets/header.dart';
import '../Widgets/job_card.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  const JobSeekerHomeScreen({super.key});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen> {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Column(
        children: [
          HeaderWidget(),
          Expanded(
            child: BlocBuilder<JobCubit, JobState>(
              builder: (context, state) {
                if (state is JobLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is JobLoaded) {
                  return ListView.builder(
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
                  );
                }

                if (state is JobError) {
                  return Center(child: Text(state.message));
                }

                return SizedBox();
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff1D4ED8),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 10,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "Applied",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "Alerts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
