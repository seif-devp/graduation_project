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

  // ── الشريط الأزرق العلوي المعدل ──
  Widget _buildHeader(int count) {
    return Container(
      width: double.infinity,
      // تقليل الـ padding العلوي ليتناسب مع الـ SafeArea
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.h, 24.h), 
      decoration: BoxDecoration(
        color: const Color(0xFF003C82),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        bottom: false, // نترك الـ SafeArea تتعامل مع الجزء العلوي فقط
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interviews',
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '$count scheduled',
              style: TextStyle(fontSize: 14.sp, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InterviewCubitEmployer(InterviewsRepositoryImpl())
        ..loadAllInterviewsForEmployer(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        // استخدمنا الـ SafeArea داخل الـ Header، لذا لا نحتاج لجعل الـ Scaffold بـ SafeArea كاملة
        body: BlocBuilder<InterviewCubitEmployer, InterviewStateEmployer>(
          builder: (context, state) {
            // ... (باقي كود الـ builder يظل كما هو)
            if (state is InterviewEmployerLoading) {
              return Column(
                children: [
                  _buildHeader(0),
                  const Expanded(child: Center(child: loading)),
                ],
              );
            }
            if (state is InterviewEmployerError) {
              return Column(
                children: [
                  _buildHeader(0),
                  Expanded(child: Center(child: Text(state.message))),
                ],
              );
            }
            if (state is InterviewsEmployerEmpty) {
              return Column(
                children: [
                  _buildHeader(0),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 96, height: 96,
                              decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                              child: Icon(Icons.calendar_today, size: 36, color: Colors.blue.shade400),
                            ),
                            const SizedBox(height: 20),
                            const Text('No Interviews Scheduled', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const SizedBox(width: 300, child: Text('check your Applicants To schedule Interview with The Best candidate.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => context.go('/applications_swip'),
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
                              child: const Text('Browse candidates Applicants', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is InterviewEmployerLoaded) {
              return Column(
                children: [
                  _buildHeader(state.interviewsEmployer.length),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: RefreshIndicator(
                        onRefresh: () => context.read<InterviewCubitEmployer>().loadAllInterviewsForEmployer(),
                        child: ListView.separated(
                          padding: EdgeInsets.zero, // تأكد من عدم وجود padding إضافي
                          itemCount: state.interviewsEmployer.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) => InterviewCardEmployer(
                            interviewemployer: state.interviewsEmployer[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return _buildHeader(0);
          },
        ),
      ),
    );
  }
}