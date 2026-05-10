import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/job_application_progress/presentation/cubit/application_progress_cubit.dart';
import 'package:graduation_project/features/job_application_progress/presentation/cubit/application_progress_state.dart';
import 'package:graduation_project/features/job_application_progress/presentation/widgets/application_card.dart';
import 'package:graduation_project/features/job_application_progress/presentation/widgets/application_detail_widget.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_cubit.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Applied Jobs',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Track your application status',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<ApplicationProgressCubit,
                  ApplicationProgressState>(
                builder: (context, state) {
                  if (state is ApplicationProgressLoading &&
                      state is! ApplicationProgressLoaded) {
                    return const Center(child: CircularProgressIndicator());
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

                          // Safely parse properties dynamically to avoid crashes if model properties vary slightly
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
                              // 1. نجيب الـ jobId بس من موديل التقديم
                              final String? currentJobId =
                                  app.jobId?.toString();

                              if (currentJobId == null ||
                                  currentJobId == 'null') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Job ID is missing.')),
                                );
                                return;
                              }

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  // 3. نستدعي الكيوبت اللي بيجيب الـ JobModel
                                  return BlocProvider(
                                    create: (context) => JobDetailsCubit(
                                        JobDetailsRepo(
                                            JobDetailsRemoteDataSource()))
                                      ..fetchJobDetails(currentJobId),
                                    child: BlocBuilder<JobDetailsCubit,
                                        JobDetailsState>(
                                      builder: (context, state) {
                                        // حالة التحميل: بنعرض مسار تحميل جوه البوب أب
                                        if (state is JobDetailsLoading) {
                                          return DraggableScrollableSheet(
                                            initialChildSize: 0.9,
                                            builder: (_, __) => Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              child:
                                                  const Center(child: loading),
                                            ),
                                          );
                                        }

                                        // حالة النجاح: الداتا رجعت في الـ JobModel وهنعرضها
                                        else if (state is JobDetailsSuccess) {
                                          final jobData = state
                                              .job; // 👈 ده بقى الـ JobModel الصح

                                          return ApplicationDetailWidget(
                                            // بنستخدم الداتا من jobData، ولو فاضية بناخد اللي كانت في كارت التقديم
                                            jobTitle: jobData.title.isNotEmpty
                                                ? jobData.title
                                                : jobTitle,
                                            companyName:
                                                jobData.companyName.isNotEmpty
                                                    ? jobData.companyName
                                                    : companyName,
                                            location:
                                                jobData.location.isNotEmpty
                                                    ? jobData.location
                                                    : 'Unknown',
                                            salary: jobData.salary.isNotEmpty
                                                ? jobData.salary
                                                : 'Not specified',

                                            // دول بناخدهم من التقديم نفسه عشان مش في المودل بتاع الوظيفة
                                            status: status,
                                            appliedDate: formattedDate,

                                            description: jobData
                                                    .description.isNotEmpty
                                                ? jobData.description
                                                : 'No description available.',
                                            requirements:
                                                jobData.requirements.isNotEmpty
                                                    ? jobData.requirements
                                                    : [],
                                          );
                                        }

                                        // حالة الخطأ
                                        else if (state is JobDetailsError) {
                                          return DraggableScrollableSheet(
                                            initialChildSize: 0.5,
                                            builder: (_, __) => Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              child: Center(
                                                child: Text(state.message,
                                                    style: const TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ),
                                          );
                                        }

                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  );
                                },
                              );
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
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              child: Icon(Icons.check_circle_outline,
                  size: 36, color: Colors.blue.shade400),
            ),
            const SizedBox(height: 20),
            const Text('No Applications Yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const SizedBox(
              width: 300,
              child: Text(
                'Start applying to jobs and track your progress here.',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              child: const Text(
                'Find Jobs',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
