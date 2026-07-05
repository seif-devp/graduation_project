import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/cubit/home_employer_cubit.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/cubit/home_employer_state.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedType; // null = All
  String? _selectedSalaryFilter; // null = All, 'above' = >2000, 'below' = <2000

  @override
  void initState() {
    super.initState();
    context.read<EmployerHomeCubit>().fetchHomeDataAndJobs();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // بيقارن نوعين من غير ما يهتم بالمسافات أو حالة الحروف
  // (Full Time == FullTime == full time)
  bool _typesMatch(String? a, String? b) {
    if (a == null || b == null) return false;
    String normalize(String s) => s.replaceAll(' ', '').toLowerCase();
    return normalize(a) == normalize(b);
  }

  // أنواع شائعة بتفضل ظاهرة في الفلتر دايمًا، حتى لو مفيش وظائف بيها لسه
  static const List<String> _commonJobTypes = [
    'Full Time',
    'Part Time',
    'Remote',
  ];
  double? _parseSalary(dynamic salary) {
    final text = (salary ?? '').toString();
    final match = RegExp(r'[\d]+(\.\d+)?').firstMatch(text.replaceAll(',', ''));
    if (match == null) return null;
    return double.tryParse(match.group(0)!);
  }

  List<dynamic> _applyFilters(List<dynamic> jobs) {
    return jobs.where((job) {
      final matchesSearch = _searchQuery.isEmpty ||
          (job.title ?? '').toString().toLowerCase().contains(_searchQuery) ||
          (job.companyName ?? '')
              .toString()
              .toLowerCase()
              .contains(_searchQuery) ||
          (job.location ?? '')
              .toString()
              .toLowerCase()
              .contains(_searchQuery);

      final matchesType =
          _selectedType == null || _typesMatch(job.type, _selectedType);

      bool matchesSalary = true;
      if (_selectedSalaryFilter != null) {
        final salaryValue = _parseSalary(job.salary);
        if (salaryValue == null) {
          matchesSalary = false;
        } else if (_selectedSalaryFilter == 'above') {
          matchesSalary = salaryValue > 2000;
        } else if (_selectedSalaryFilter == 'below') {
          matchesSalary = salaryValue < 2000;
        }
      }

      return matchesSearch && matchesType && matchesSalary;
    }).toList();
  }

  void _openFilterSheet(BuildContext context, List<dynamic> allJobs) {
    // بندمج الأنواع الشائعة الثابتة مع أي نوع مخصوص موجود فعليًا في الداتا
    // ومش موجود في القايمة الثابتة (زي لو حد ضاف نوع غريب وهو بيبوست وظيفة)
    final dataTypes = allJobs
        .map((job) => (job.type ?? '').toString())
        .where((t) => t.isNotEmpty)
        .toSet();

    final types = [
      ..._commonJobTypes,
      ...dataTypes.where((t) =>
          !_commonJobTypes.any((common) => _typesMatch(common, t))),
    ];

    String? tempSelected = _selectedType;
    String? tempSalaryFilter = _selectedSalaryFilter;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter Jobs",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Job Type",
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      ChoiceChip(
                        label: const Text("All"),
                        selected: tempSelected == null,
                        onSelected: (_) {
                          setSheetState(() => tempSelected = null);
                        },
                      ),
                      ...types.map((type) {
                        return ChoiceChip(
                          label: Text(type),
                          selected: tempSelected == type,
                          onSelected: (_) {
                            setSheetState(() => tempSelected = type);
                          },
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Salary",
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      ChoiceChip(
                        label: const Text("All"),
                        selected: tempSalaryFilter == null,
                        onSelected: (_) {
                          setSheetState(() => tempSalaryFilter = null);
                        },
                      ),
                      ChoiceChip(
                        label: const Text("Above 2000"),
                        selected: tempSalaryFilter == 'above',
                        onSelected: (_) {
                          setSheetState(() => tempSalaryFilter = 'above');
                        },
                      ),
                      ChoiceChip(
                        label: const Text("Below 2000"),
                        selected: tempSalaryFilter == 'below',
                        onSelected: (_) {
                          setSheetState(() => tempSalaryFilter = 'below');
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setSheetState(() {
                              tempSelected = null;
                              tempSalaryFilter = null;
                            });
                            setState(() {
                              _selectedType = null;
                              _selectedSalaryFilter = null;
                            });
                            Navigator.pop(sheetContext);
                          },
                          child: const Text("Reset"),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052D4),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedType = tempSelected;
                              _selectedSalaryFilter = tempSalaryFilter;
                            });
                            Navigator.pop(sheetContext);
                          },
                          child: const Text("Apply",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "My Jobs",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0052D4),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<EmployerHomeCubit, EmployerHomeState>(
        listener: (context, state) {
          if (state is DeleteJobSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Job deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MyJobsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MyJobsSuccess) {
            final allJobs = state.jobsList;
            final filteredJobs = _applyFilters(allJobs);

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search by title, company, location",
                              hintStyle: TextStyle(fontSize: 13.sp),
                              prefixIcon: const Icon(Icons.search,
                                  color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 8.w),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        decoration: BoxDecoration(
                          color: (_selectedType != null ||
                                  _selectedSalaryFilter != null)
                              ? const Color(0xFF0052D4)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: (_selectedType != null ||
                                    _selectedSalaryFilter != null)
                                ? Colors.white
                                : Colors.grey[800],
                          ),
                          onPressed: () => _openFilterSheet(context, allJobs),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedType != null || _selectedSalaryFilter != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        if (_selectedType != null)
                          Chip(
                            label: Text("Type: $_selectedType"),
                            onDeleted: () =>
                                setState(() => _selectedType = null),
                            backgroundColor: const Color(0xFFF1F5F9),
                          ),
                        if (_selectedSalaryFilter != null)
                          Chip(
                            label: Text(
                              _selectedSalaryFilter == 'above'
                                  ? "Salary: Above 2000"
                                  : "Salary: Below 2000",
                            ),
                            onDeleted: () =>
                                setState(() => _selectedSalaryFilter = null),
                            backgroundColor: const Color(0xFFF1F5F9),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: filteredJobs.isEmpty
                      ? Center(
                          child: Text(
                            allJobs.isEmpty
                                ? "No jobs posted yet"
                                : "No jobs match your search or filter",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: filteredJobs.length,
                          itemBuilder: (context, index) {
                            final job = filteredJobs[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: _buildJobCard(context, job),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          if (state is MyJobsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, dynamic job) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  job.type ?? "Full-time",
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
              ),
              // ✅ سلة الحذف
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmDelete(context, job.id.toString()),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            job.title ?? "No title",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            job.companyName ?? "",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
              Icons.location_on_outlined, job.location ?? "Not specified"),
          SizedBox(height: 8.h),
          _buildInfoRow(Icons.monetization_on_outlined,
              "${job.salary ?? 'Not specified'} \$"),
          SizedBox(height: 12.h),
          const Divider(),
          Text(
            "Description:",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            job.description ?? "No description",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700], fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey[500]),
        SizedBox(width: 8.w),
        Text(text, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
      ],
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Delete Job"),
        content: const Text("Are you sure you want to delete this job?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<EmployerHomeCubit>().removeJob(id);
              Navigator.pop(c);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}