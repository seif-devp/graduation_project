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
  @override
  void initState() {
    super.initState();
    // ✅ بيعمل fetch لما الصفحة تفتح
    context.read<EmployerHomeCubit>().fetchHomeDataAndJobs();
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
        iconTheme: const IconThemeData(color: Colors.black),
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
            final jobs = state.jobsList;

            if (jobs.isEmpty) {
              return const Center(child: Text("No jobs posted yet"));
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildJobCard(context, job),
                );
              },
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
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
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
          _buildInfoRow(Icons.location_on_outlined, job.location ?? "Not specified"),
          SizedBox(height: 8.h),
          _buildInfoRow(Icons.monetization_on_outlined, "${job.salary ?? 'Not specified'} \$"),
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