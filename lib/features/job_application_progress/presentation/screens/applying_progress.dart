import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart'; // تأكد من استيراد الـ primaryColor
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/remote_source.dart';
import 'package:graduation_project/features/apply_now_seeker.dart/data/repo.dart';
import 'package:graduation_project/features/job_application_progress/presentation/cubit/application_progress_cubit.dart';
import 'package:graduation_project/features/job_application_progress/presentation/cubit/application_progress_state.dart';
import 'package:graduation_project/features/job_application_progress/presentation/widgets/application_card.dart';
import 'package:graduation_project/features/job_application_progress/presentation/widgets/application_detail_widget.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_cubit.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/job_details/data/ai_remote_source.dart';
import 'package:graduation_project/features/job_details/data/job_application_repo.dart';
import 'package:graduation_project/features/job_details/data/remote_detail_source.dart';
import 'package:graduation_project/features/job_details/data/repo_imp_detail.dart';

class ApplicationProgressScreen extends StatefulWidget {
  const ApplicationProgressScreen({super.key});

  @override
  State<ApplicationProgressScreen> createState() =>
      _ApplicationProgressScreenState();
}

class _ApplicationProgressScreenState extends State<ApplicationProgressScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ApplicationProgressCubit>().getMyApplications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // خلفية فاتحة تظهر تحت الدوران
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── الـ Header الملون مع الدوران من أسفل ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 60.h, // مسافة علوية لتجنب الـ Notch
              left: 20.w,
              right: 20.w,
              bottom: 40.h,
            ),
            decoration: BoxDecoration(
              color: primaryColor, // اللون البنفسجي/الأزرق
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child:
                BlocBuilder<ApplicationProgressCubit, ApplicationProgressState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Applied Jobs',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      state is ApplicationProgressLoaded
                          ? '${state.applications.length} applications tracked'
                          : 'Track your application status',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ── منطقة عرض الداتا (ListView) ──
          Expanded(
            child:
                BlocBuilder<ApplicationProgressCubit, ApplicationProgressState>(
              builder: (context, state) {
                if (state is ApplicationProgressLoading &&
                    state is! ApplicationProgressLoaded) {
                  return const Center(child: loading);
                } else if (state is ApplicationProgressError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    ),
                  );
                } else if (state is ApplicationProgressLoaded) {
                  if (state.applications.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<ApplicationProgressCubit>()
                          .getMyApplications(refresh: true);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.applications.length +
                          (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= state.applications.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(child: loading),
                          );
                        }

                        final dynamic app = state.applications[index];

                        // Parsing data...
                        final String jobTitle = app.jobTitle ?? 'Unknown Job';
                        final String companyName =
                            app.companyName ?? 'Unknown Company';
                        final String status = app.status ?? 'sent';
                        final String matchPercentage =
                            (app.aiMatchScore ?? '0').toString();

                        final DateTime? rawDate = app.appliedAt;
                        String formattedDate = 'Recently';
                        if (rawDate != null) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          formattedDate =
                              '${months[rawDate.month - 1]} ${rawDate.day}, ${rawDate.year}';
                        }

                        return ApplicationCard(
                          jobTitle: jobTitle,
                          companyName: companyName,
                          matchPercentage: matchPercentage,
                          status: status,
                          appliedDate: formattedDate,
                          onTap: () {
                            _showDetailSheet(context, app, jobTitle,
                                companyName, status, formattedDate);
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ميثود مساعدة لفتح الـ Sheet (عشان الكود يكون أنظف)
  void _showDetailSheet(BuildContext context, dynamic app, String jobTitle,
      String companyName, String status, String formattedDate) {
    final String? currentJobId = app.jobId?.toString();

    if (currentJobId == null || currentJobId == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job ID is missing.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider(
          create: (context) => JobDetailsCubit(
            JobDetailsRepo(JobDetailsRemoteDataSource()),
            JobApplicationRepository(
              aiRemoteSource: AiMatchRemoteDataSource(),
              dotNetRepo: ApplicationRepository(ApplicationRemoteDataSource()),
            ),
          ),
          child: BlocBuilder<JobDetailsCubit, JobDetailsState>(
            builder: (context, state) {
              if (state is JobDetailsLoading) {
                return _buildSheetWrapper(const Center(child: loading));
              } else if (state is JobDetailsSuccess) {
                final jobData = state.job;
                return ApplicationDetailWidget(
                  jobTitle: jobData.title.isNotEmpty ? jobData.title : jobTitle,
                  companyName: jobData.companyName.isNotEmpty
                      ? jobData.companyName
                      : companyName,
                  location: jobData.location.isNotEmpty
                      ? jobData.location
                      : 'Unknown',
                  salary: jobData.salary.isNotEmpty
                      ? jobData.salary
                      : 'Not specified',
                  status: status,
                  appliedDate: formattedDate,
                  description: jobData.description.isNotEmpty
                      ? jobData.description
                      : 'No description available.',
                  requirements: jobData.requirements.isNotEmpty
                      ? jobData.requirements
                      : [],
                );
              } else if (state is JobDetailsError) {
                return _buildSheetWrapper(Center(
                    child: Text(state.message,
                        style: const TextStyle(color: Colors.red))));
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildSheetWrapper(Widget child) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      builder: (_, __) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
                color: Colors.blue.shade50, shape: BoxShape.circle),
            child: Icon(Icons.check_circle_outline,
                size: 36, color: Colors.blue.shade400),
          ),
          const SizedBox(height: 20),
          const Text('No Applications Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Start applying to jobs and track your progress here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/jobPage'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D4ED8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            child:
                const Text('Find Jobs', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
