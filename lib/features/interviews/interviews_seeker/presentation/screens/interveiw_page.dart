import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/data/repo_imp.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/presentation/cubit/interview_cubit.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/presentation/cubit/interview_state.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/widgets/card_interveiw.dart';

class InterviewsPage extends StatelessWidget {
  const InterviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InterviewCubit(
        RepoImp(),
      )..loadInterviews(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<InterviewCubit, InterviewState>(
            builder: (context, state) {
              if (state is InterviewLoading) {
                return const Center(child: loading);
              }

              if (state is InterviewError) {
                return Center(child: Text(state.message));
              }
              if (state is InterviewEmpty) {
                // Empty state when there are no interviews

                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interviews',
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1D23)),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Upcoming scheduled meetings',
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 40.h),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.calendar_today,
                                    size: 36, color: Colors.blue.shade400),
                              ),
                              const SizedBox(height: 20),
                              const Text('No Interviews Scheduled',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              const SizedBox(
                                width: 300,
                                child: Text(
                                  'Keep applying! Your upcoming interview schedules will appear here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => context.go('/jobPage'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1D4ED8),
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 14),
                                ),
                                child: const Text(
                                  'Browse Open Roles',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is InterviewLoaded) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interviews',
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1D23)),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${state.interviews.length} scheduled',
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.interviews.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              InterviewCard(interview: state.interviews[index]),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
