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
      create: (context) =>
          ApplicantsCubit(ApplicantsRepository(ApplicantsRemoteDataSource()))
            ..fetchAllJobs(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Your Jobs')),
        body: BlocBuilder<ApplicantsCubit, ApplicantsState>(
          builder: (context, state) {
            if (state.jobsStatus == JobsStatus.loading)
              return const Center(child: CircularProgressIndicator());
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.jobs.length,
              itemBuilder: (context, index) {
                final job = state.jobs[index];
                return JobCardwidgetEmployer(
                  job: job,
                  onTap: () async {
                    // الانتظار حتى العودة من شاشة المتقدمين
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApplicantsScreen(jobId: job.id),
                      ),
                    );
                    // تحديث القائمة فور العودة لمسح المتقدمين الذين تم قبولهم/رفضهم
                    if (context.mounted) {
                      context.read<ApplicantsCubit>().fetchAllJobs();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
