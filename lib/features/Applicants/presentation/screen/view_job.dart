import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Applicants/data/remote_data_source.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_cubit.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';
import 'package:graduation_project/features/Applicants/presentation/screen/application_screen.dart';
import 'package:graduation_project/features/Applicants/widgets/card_widget.dart';

class JobPageEmployer extends StatelessWidget {
  const JobPageEmployer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApplicantsCubit(
        ApplicantsRepository(ApplicantsRemoteDataSource()),
      )..fetchAllJobs(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Manage Your Jobs',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<ApplicantsCubit, ApplicantsState>(
          builder: (context, state) {
            if (state.jobsStatus == JobsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.jobsStatus == JobsStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Something went wrong',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state.jobs.isEmpty) {
              return const Center(child: Text('No Jobs Found'));
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.jobs.length,
              itemBuilder: (context, index) {
                final job = state.jobs[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: JobCardwidgetEmployer(
                    job: job,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ApplicantsCubit(
                              ApplicantsRepository(ApplicantsRemoteDataSource()),
                            ),
                            child: ApplicantsScreen(jobId: job.id),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}