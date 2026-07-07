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

// لو عندك صفحة تفاصيل، اعملها Import هنا
// import 'package:graduation_project/features/job_details/presentation/job_details_screen.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  double _minSalary = 0;
  bool _remoteOnly = false;
  bool _postedLast24h = false;
  String _searchQuery = ""; // متغير البحث

  // دالة الفلترة المجمعة (بحث نصي + فلاتر متقدمة)
  List<JobModelResponse> _applyFilters(List<JobModelResponse> jobs) {
    return jobs.where((job) {
      final salaryValue = double.tryParse(job.salary.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      
      // 1. فلتر البحث النصي (مقارنة الاسم)
      bool matchesSearch = job.title.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // 2. فلتر الحد الأدنى للراتب
      bool matchesSalary = salaryValue >= _minSalary;
      
      // 3. فلتر العمل عن بعد
      bool matchesRemote = !_remoteOnly || job.location.toLowerCase().contains('remote');
      
      // 4. فلتر آخر 24 ساعة
      bool matchesTime = true;
      if (_postedLast24h) {
        final postedDate = DateTime.tryParse(job.postedAt);
        if (postedDate == null) {
          matchesTime = false;
        } else {
          matchesTime = DateTime.now().difference(postedDate).inHours <= 24;
        }
      }
      
      return matchesSearch && matchesSalary && matchesRemote && matchesTime;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobSeekerCubit((JobSeekerRepositoryImpl(JobsRemoteDataSource())))..fetchJobs(),
      child: Builder(
        builder: (context) {
          return Scaffold(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search by job title",
                              hintStyle: TextStyle(fontSize: 13.sp),
                              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                            ),
                            // تحديث قيمة البحث فوراً وتحديث الشاشة
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
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
                        // تطبيق الفلاتر والبحث على القائمة
                        final filteredJobs = _applyFilters(state.jobs);
                        
                        return filteredJobs.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                itemCount: filteredJobs.length,
                                itemBuilder: (ctx, index) => Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: GestureDetector(
                                    onTap: () {
                                      // TODO: قم بتفعيل هذا الكود للانتقال لصفحة التفاصيل
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => JobDetailsScreen(jobId: filteredJobs[index].id), // أو ابعت الوظيفة كاملة
                                      //   ),
                                      // );
                                    },
                                    // الكارت بتاعك جوه GestureDetector
                                    child: JobCardwidget(job: filteredJobs[index]),
                                  ),
                                ),
                              );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 64.r, color: Colors.grey.shade400),
          SizedBox(height: 16.h),
          Text("No jobs found", style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp))
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              SizedBox(height: 20.h),
              Text("Filter Jobs", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.h),
              _buildSlider(setSheetState),
              Divider(height: 30.h),
              _buildSwitch("Remote Only", _remoteOnly, (val) => setSheetState(() => _remoteOnly = val)),
              _buildSwitch("Posted last 24h", _postedLast24h, (val) => setSheetState(() => _postedLast24h = val)),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    setState(() {}); // تحديث الـ UI الأساسي لتطبيق الفلاتر
                    Navigator.pop(ctx);
                  },
                  child: const Text("Apply Filters", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(Function setSheetState) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Min Salary", style: TextStyle(fontWeight: FontWeight.w600)),
            Text("\$${_minSalary.toInt()}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))
          ],
        ),
        Slider(
          value: _minSalary,
          min: 0,
          max: 5000,
          divisions: 50,
          activeColor: primaryColor,
          onChanged: (val) => setSheetState(() => _minSalary = val),
        ),
      ],
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      value: value,
      activeColor: primaryColor,
      onChanged: onChanged,
    );
  }
}