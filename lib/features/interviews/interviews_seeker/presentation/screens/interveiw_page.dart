import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart';
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
        // خلفية الصفحة بالكامل هي اللون الفاتح
        backgroundColor: const Color(0xFFF8FAFC),
        body: BlocBuilder<InterviewCubit, InterviewState>(
          builder: (context, state) {
            return Column(
              children: [
                // ── الـ Header الأزرق مع الدوران من أسفل ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 60.h, // مسافة للنوتش
                    left: 20.w,
                    right: 20.w,
                    bottom: 40.h, // مسافة إضافية تحت الكلام عشان الدوران يبان
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor, // اللون البنفسجي/الأزرق
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interviews',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        state is InterviewLoaded
                            ? '${state.interviews.length} scheduled'
                            : 'Upcoming scheduled meetings',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── منطقة المحتوى (ليستة المقابلات) ──
                Expanded(
                  child: _buildBodyContent(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── عرض المحتوى بناءً على حالة الـ Bloc ──
  Widget _buildBodyContent(BuildContext context, InterviewState state) {
    if (state is InterviewLoading) {
      return const Center(child: loading);
    }

    if (state is InterviewError) {
      return Center(child: Text(state.message));
    }

    if (state is InterviewEmpty) {
      return _buildEmptyWidget(context);
    }

    if (state is InterviewLoaded) {
      return ListView.separated(
        // الـ padding هنا بيبدأ من تحت الهيدر مباشرة
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        itemCount: state.interviews.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) =>
            InterviewCard(interview: state.interviews[index]),
      );
    }

    return const SizedBox();
  }

  // ── شكل الـ Empty State ──
  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 60.sp, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          const Text(
            'No Interviews Scheduled',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.go('/jobPage'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Browse Open Roles',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
