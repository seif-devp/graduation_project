import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/remote_source_recomendion.dart';
import 'package:graduation_project/features/Home/home_seeker/Data/repo_imp_recomend.dart';
import 'package:graduation_project/features/Home/home_seeker/presentation/Widgets/Suggested.dart';
import 'package:graduation_project/features/Home/home_seeker/presentation/Widgets/header.dart';
import 'package:graduation_project/features/Home/home_seeker/presentation/Widgets/job_card.dart';
import 'package:graduation_project/features/Home/home_seeker/presentation/controller/job_Seeker_cubit.dart';
import 'package:graduation_project/features/Home/home_seeker/presentation/controller/job_Seeker_state.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  const JobSeekerHomeScreen({super.key});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _collapseController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _collapseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if (!_collapseController.isAnimating && _collapseController.value != 1.0) {
        _collapseController.forward();
      }
    } else if (direction == ScrollDirection.forward) {
      if (!_collapseController.isAnimating && _collapseController.value != 0.0) {
        _collapseController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _collapseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // هنا التعديل الجوهري: حقن الـ Repo والـ DataSource جوه الكيوبت
    return BlocProvider(
      create: (context) => JobSeekerCubit(
        HomeSeekerRepoImpl(HomeSeekerRemoteDataSource()),
      )..loadJobs(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            HeaderWidget(collapseAnimation: _collapseController),
            BlocBuilder<JobSeekerCubit, JobState>(
              builder: (context, state) {
                // حالة التحميل
                if (state is JobLoading) {
                  return const Expanded(child: Center(child: loading));
                }

                // حالة النجاح وعرض الداتا
                if (state is JobLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: state.jobs.length,
                      itemBuilder: (context, index) {
                        final job = state.jobs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0) ...[
                              const SectionTitle(),
                              const SizedBox(height: 12),
                            ],
                            // الكارت بياخد بيانات الـ JobModel اللي جاية من الـ Swagger
                            JobCard(job: job),
                          ],
                        );
                      },
                    ),
                  );
                }

                // حالة الخطأ
                if (state is JobError) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}