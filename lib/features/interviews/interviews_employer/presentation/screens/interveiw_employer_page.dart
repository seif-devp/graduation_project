import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/interviews/interviews_employer/data/repo_employer_imp.dart';
import 'package:graduation_project/features/interviews/interviews_employer/presentation/cubit/interview_employer_cubit.dart';
import 'package:graduation_project/features/interviews/interviews_employer/presentation/cubit/interview_employer_state.dart';
import 'package:graduation_project/features/interviews/interviews_employer/widgets/card_interveiw.dart';

class InterviewsPageEmployer extends StatelessWidget {
  const InterviewsPageEmployer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InterviewCubitEmployer(
        RepoImpEmployer(),
      )..loadInterviews(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<InterviewCubitEmployer, InterviewStateEmployer>(
            builder: (context, state) {
              if (state is InterviewEmployerLoading) {
                return const Center(child: loading);
              }
              if (state is InterviewEmployerError) {
                return Center(child: Text(state.message));
              }
              if (state is InterviewsEmployerEmpty) {
                
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
                                    'check your Applicants To schedule Interview with The Best candidate.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => context.go('/applications_swip'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:primaryColor,
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 28, vertical: 14),
                                  ),
                                  child: const Text('Browse candidates Applicants',style: TextStyle(color: Colors.white),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                

                
              }
              else if(state is InterviewEmployerLoaded){
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
                        '${state.interviewsEmployer.length} scheduled',
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.interviewsEmployer.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              InterviewCardEmployer(
                            interviewemployer: state.interviewsEmployer[index],
                          ),
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
