import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/Suggested.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/header.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/job_card.dart';
import 'package:graduation_project/features/Home/presentation/controller/job_Seeker_cubit.dart';
import 'package:graduation_project/features/Home/presentation/controller/job_Seeker_state.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  const JobSeekerHomeScreen({super.key});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen>
    with TickerProviderStateMixin {
  int currentIndex = 6;
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
      // Scrolling DOWN -> Collapse
      if (!_collapseController.isAnimating &&
          _collapseController.value != 1.0) {
        _collapseController.forward();
      }
    } else if (direction == ScrollDirection.forward) {
      // Scrolling UP -> Expand
      if (!_collapseController.isAnimating &&
          _collapseController.value != 0.0) {
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
    return BlocProvider(
      create: (context) => JobSeekerCubit()..loadJobs(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            HeaderWidget(collapseAnimation: _collapseController),
            BlocBuilder<JobSeekerCubit, JobState>(
              builder: (context, state) {
                if (state is JobLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is JobLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent:
                            BouncingScrollPhysics(), // بتدي نعومة أكتر في الـ iOS والـ Web
                      ),
                      padding: EdgeInsets.all(16),
                      itemCount: state.jobs.length,
                      itemBuilder: (context, index) {
                        final job = state.jobs[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0) ...[
                              SectionTitle(),
                              SizedBox(height: 12),
                            ],
                            JobCard(job: job),
                          ],
                        );
                      },
                    ),
                  );
                }

                if (state is JobError) {
                  return Center(child: Text(state.message));
                }

                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
