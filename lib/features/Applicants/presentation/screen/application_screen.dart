import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/Applicants/data/remote_data_source.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/logic/entity.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_cubit.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';
import 'package:graduation_project/features/Applicants/widgets/app_card_widget.dart';
import 'package:graduation_project/features/Applicants/widgets/empty_veiw.dart';
import 'package:graduation_project/features/Applicants/widgets/schedule_inerview_dialog.dart';
import 'package:graduation_project/features/Applicants/widgets/swip.dart';

class ApplicantsScreen extends StatelessWidget {
  final String jobId;
  const ApplicantsScreen({super.key, required this.jobId});

  static const Color primaryBlue = Color(0xFF033B7A);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApplicantsCubit(ApplicantsRepository(ApplicantsRemoteDataSource()))..loadApplicants(jobId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F5),
        appBar: AppBar(
          backgroundColor: primaryBlue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Applicants", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<ApplicantsCubit, ApplicantsState>(
          builder: (context, state) {
            if (state.isLoading) return const Center(child: loading);
            if (state.applicants.isEmpty || state.currentIndex >= state.applicants.length) return const EmptyView();

            final current = state.applicants[state.currentIndex];
            final total = state.applicants.length;
            final progress = (state.currentIndex + 1) / total;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w), // إزالة الـ vertical من هنا للتحكم الكامل
                child: Column(
                  children: [
                    // مسافة أكبر قبل العداد (لإبعاد العناصر عن الـ AppBar)
                    SizedBox(height: 25.h), 
                    
                    // --- عداد احترافي ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Applicant ${state.currentIndex + 1} of $total", 
                             style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                        Text("${(progress * 100).toInt()}% Reviewed", 
                             style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade300, valueColor: const AlwaysStoppedAnimation(primaryBlue)),
                    
                    // مسافة إضافية بين العداد والكارت لإنزال الكارت للأسفل
                    SizedBox(height: 30.h), 
                    
                    // --- كارت المتقدم بحجم موسع جداً ---
                    Expanded(
                      flex: 6, // زيادة الـ flex لتكبير مساحة الكارت
                      child: Dismissible(
                        key: Key(current.id),
                        onDismissed: (direction) {
                          direction == DismissDirection.startToEnd 
                              ? context.read<ApplicantsCubit>().swipeRight() 
                              : context.read<ApplicantsCubit>().swipeLeft();
                        },
                        background: const SwipeIndicator(icon: Icons.check, color: Colors.green, alignment: Alignment.centerLeft),
                        secondaryBackground: const SwipeIndicator(icon: Icons.close, color: Colors.red, alignment: Alignment.centerRight),
                        child: ApplicantCard(
                          applicant: current,
                          onReject: () => context.read<ApplicantsCubit>().swipeLeft(),
                          onAccept: () => context.read<ApplicantsCubit>().swipeRight(),
                          onInterview: () => _showInterviewDialog(context, current),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showInterviewDialog(BuildContext context, dynamic current) {
    showDialog(
      context: context,
      builder: (_) => ScheduleInterviewDialog(
        applicant: ApplicantEntity(
          id: current.id,
          name: current.seekerName,
          matchScore: current.aiMatchScore,
          appliedDate: current.appliedAt.toString().split('.')[0],
        ),
      ),
    );
  }
}