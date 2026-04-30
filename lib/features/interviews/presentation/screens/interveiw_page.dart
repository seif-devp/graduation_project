import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/interviews/data/repo_imp.dart';
import 'package:graduation_project/features/interviews/presentation/cubit/interview_cubit.dart';
import 'package:graduation_project/features/interviews/presentation/cubit/interview_state.dart';
import 'package:graduation_project/features/interviews/widgets/card_interveiw.dart';

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
              if (state is InterviewLoaded) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Interviews',
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D23)),
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
