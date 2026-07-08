import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/features/Applicants/data/remote_data_source.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_cubit.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';
import 'package:graduation_project/features/Applicants/presentation/screen/application_screen.dart';
import 'package:graduation_project/features/Applicants/widgets/card_widget.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class JobPageEmployer extends StatefulWidget {
  const JobPageEmployer({super.key});

  @override
  State<JobPageEmployer> createState() => _JobPageEmployerState();
}

class _JobPageEmployerState extends State<JobPageEmployer> {
  bool _lastWeekOnly = false;
  bool _remoteOnly = false;
  String _typeFilter = 'All';
  String _salaryFilter = 'All';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JobModelResponse> _applyLocalFilters(List<JobModelResponse> jobs) {
    return jobs.where((job) {
      if (_searchQuery.isNotEmpty &&
          !job.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      if (_lastWeekOnly) {
        final postedDate = DateTime.tryParse(job.postedAt);
        if (postedDate == null) return false;

        final diff = DateTime.now().difference(postedDate);
        if (diff.inDays > 7) return false;
      }

      if (_remoteOnly && !job.location.toLowerCase().contains('remote')) {
        return false;
      }

      if (_typeFilter != 'All' &&
          job.type.toLowerCase() != _typeFilter.toLowerCase()) {
        return false;
      }

      if (_salaryFilter != 'All') {
        final salaryValue =
            double.tryParse(job.salary.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

        if (_salaryFilter == 'Above' && salaryValue <= 2000) {
          return false;
        }

        if (_salaryFilter == 'Below' && salaryValue > 2000) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApplicantsCubit(
        ApplicantsRepository(
          ApplicantsRemoteDataSource(),
        ),
      )..fetchAllJobs(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: const Text(
            'Manage Your Jobs',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by job title',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showFilterSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ApplicantsCubit, ApplicantsState>(
                builder: (context, state) {
                  if (state.jobsStatus == JobsStatus.loading) {
                    return const Center(
                      child: loading,
                    );
                  }

                  final filteredJobs = _applyLocalFilters(state.jobs);

                  if (filteredJobs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "No jobs match your filters",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];

                      return JobCardwidgetEmployer(
                        job: job,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ApplicantsScreen(
                                jobId: job.id,
                              ),
                            ),
                          );

                          if (context.mounted) {
                            context.read<ApplicantsCubit>().fetchAllJobs();
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        bool tempLastWeek = _lastWeekOnly;
        bool tempRemote = _remoteOnly;
        String tempType = _typeFilter;
        String tempSalary = _salaryFilter;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter Jobs",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Posted in last week",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: tempLastWeek,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setSheetState(() {
                        tempLastWeek = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Remote Only",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: tempRemote,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setSheetState(() {
                        tempRemote = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  const Text(
                    "Job Type",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 10,
                    children: [
                      'All',
                      'Full-time',
                      'Part-time',
                    ].map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: tempType == type,
                        selectedColor: primaryColor.withOpacity(0.15),
                        onSelected: (_) {
                          setSheetState(() {
                            tempType = type;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                  const Text(
                    "Salary",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 10,
                    children: [
                      {
                        'label': 'All',
                        'value': 'All',
                      },
                      {
                        'label': 'Above \$2000',
                        'value': 'Above',
                      },
                      {
                        'label': 'Below \$2000',
                        'value': 'Below',
                      },
                    ].map((salary) {
                      return ChoiceChip(
                        label: Text(salary['label']!),
                        selected: tempSalary == salary['value'],
                        selectedColor: primaryColor.withOpacity(0.15),
                        onSelected: (_) {
                          setSheetState(() {
                            tempSalary = salary['value']!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _lastWeekOnly = tempLastWeek;
                          _remoteOnly = tempRemote;
                          _typeFilter = tempType;
                          _salaryFilter = tempSalary;
                        });

                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        "Apply Filters",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
