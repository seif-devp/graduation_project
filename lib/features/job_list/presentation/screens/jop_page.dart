import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/widgets/job_card.dart';
import 'package:graduation_project/features/job_list/data/job_repo_imp.dart';
import 'package:graduation_project/features/job_list/domain/job_use_case.dart';
import 'package:graduation_project/features/job_list/presentation/cubit/job_list_cubit.dart';

class JopPage extends StatefulWidget {
  const JopPage({super.key});

  @override
  State<JopPage> createState() => _JopPageState();
}

class _JopPageState extends State<JopPage> {
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
              const Text(
                "Discover Jobs",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                "AI-matched positions for you",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.tune, color: Colors.blue.shade700),
              onPressed: () {},
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
              return Center(child:Text(state.massege));
            } return const SizedBox();
          },
        ),
      ),
    );
  }
}
