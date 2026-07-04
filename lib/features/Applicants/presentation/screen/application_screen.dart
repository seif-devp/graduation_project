import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/Applicants/data/remote_data_source.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_cubit.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';
import 'package:graduation_project/features/Applicants/widgets/app_card_widget.dart';
import 'package:graduation_project/features/Applicants/widgets/appbar.dart';
import 'package:graduation_project/features/Applicants/widgets/empty_veiw.dart';
import 'package:graduation_project/features/Applicants/widgets/swip.dart';

class ApplicantsScreen extends StatelessWidget {
  final String jobId;
  const ApplicantsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApplicantsCubit(
        ApplicantsRepository(ApplicantsRemoteDataSource()),
      )..loadApplicants(jobId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        appBar: const HomeAppBar(),
        body: BlocListener<ApplicantsCubit, ApplicantsState>(
          listenWhen: (p, c) => p.currentIndex != c.currentIndex || p.applicants.length != c.applicants.length,
          listener: (context, state) {
            if (state.applicants.isNotEmpty && state.currentIndex < state.applicants.length) {
              context.read<ApplicantsCubit>().markAsViewed(state.applicants[state.currentIndex]);
            }
          },
          child: BlocBuilder<ApplicantsCubit, ApplicantsState>(
            builder: (context, state) {
              if (state.isLoading) return const Center(child: loading);
              if (state.errorMessage != null) return Center(child: Text(state.errorMessage!));
              if (state.applicants.isEmpty) return const EmptyView();

              if (state.currentIndex >= state.applicants.length) {
                return const EmptyView();
              }

              final current = state.applicants[state.currentIndex];

              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Dismissible(
                    key: Key(current.id.isEmpty ? 'applicant_${state.currentIndex}' : current.id),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        context.read<ApplicantsCubit>().swipeRight();
                      } else {
                        context.read<ApplicantsCubit>().swipeLeft();
                      }
                    },
                    background: const SwipeIndicator(icon: Icons.check, color: Colors.green, alignment: Alignment.centerLeft),
                    secondaryBackground: const SwipeIndicator(icon: Icons.close, color: Colors.red, alignment: Alignment.centerRight),
                    child: ApplicantCard(applicant: current),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}