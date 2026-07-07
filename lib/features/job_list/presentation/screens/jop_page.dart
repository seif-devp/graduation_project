import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/core/widgets/job_card.dart';
import 'package:graduation_project/features/job_list/data/job_repo_imp.dart';
import 'package:graduation_project/features/job_list/data/remote_data_source.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';
import 'package:graduation_project/features/job_list/presentation/cubit/job_list_cubit.dart';
import 'package:graduation_project/features/job_list/presentation/cubit/job_list_state.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  double _minSalary = 2000;
  bool _remoteOnly = false;
  bool _postedLast24h = false;

  List<JobModelResponse> _applyLocalFilters(List<JobModelResponse> jobs) {
    return jobs.where((job) {
      final salaryValue = double.tryParse(job.salary.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      if (salaryValue < _minSalary) return false;
      if (_remoteOnly && !job.location.toLowerCase().contains('remote')) return false;
      if (_postedLast24h) {
        final postedDate = DateTime.tryParse(job.postedAt);
        if (postedDate == null) return false;
        if (DateTime.now().difference(postedDate).inHours > 24) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobSeekerCubit((JobSeekerRepositoryImpl(JobsRemoteDataSource())))..fetchJobs(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FE),
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          toolbarHeight: 80.h,
          title: Text(
            "Manage Your Jobs",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        body: Column(
          children: [
            // شريط البحث والفلتر المصغر
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45.h, // تم تصغيره لـ 45
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search by job title",
                          hintStyle: TextStyle(fontSize: 13.sp),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                        onChanged: (val) => context.read<JobSeekerCubit>().filterJobs(title: val),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    height: 45.h, 
                    width: 45.h,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                      onPressed: () => _showFilterSheet(context),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: BlocBuilder<JobSeekerCubit, JobSeekerState>(
                builder: (context, state) {
                  if (state is GetJobsLoading) return const Center(child: loading);
                  if (state is GetJobsSuccess) {
                    final filteredJobs = _applyLocalFilters(state.jobs);
                    return filteredJobs.isEmpty 
                        ? _buildEmptyState() 
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            itemCount: filteredJobs.length,
                            itemBuilder: (ctx, index) => Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: JobCardwidget(job: filteredJobs[index]),
                            ),
                          );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.work_off_outlined, size: 64.r, color: Colors.grey.shade400),
    SizedBox(height: 16.h),
    Text("No jobs found", style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp))
  ]));

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, setSheetState) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            SizedBox(height: 20.h),
            Text("Filter Jobs", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),
            _buildSlider(setSheetState),
            Divider(height: 30.h),
            _buildSwitch("Remote Only", _remoteOnly, (val) => setSheetState(() => _remoteOnly = val)),
            _buildSwitch("Posted last 24h", _postedLast24h, (val) => setSheetState(() => _postedLast24h = val)),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity, height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () { setState(() {}); Navigator.pop(ctx); },
                child: const Text("Apply Filters", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildSlider(Function setSheetState) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text("Min Salary", style: TextStyle(fontWeight: FontWeight.w600)),
      Text("\$${_minSalary.toInt()}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))
    ]),
    Slider(value: _minSalary, min: 2000, max: 20000, divisions: 36, activeColor: primaryColor, 
      onChanged: (val) => setSheetState(() => _minSalary = val)),
  ]);

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) => SwitchListTile(
    contentPadding: EdgeInsets.zero, title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
    value: value, activeColor: primaryColor, onChanged: onChanged
  );
}