import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/cubit/home_employer_cubit.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/cubit/home_employer_state.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(" My Jobs ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<EmployerHomeCubit, EmployerHomeState>(
        listener: (context, state) {
          if (state is DeleteJobSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حذف الوظيفة بنجاح'), backgroundColor: Colors.green),
            );
          }
        },
        builder: (context, state) {
          if (state is MyJobsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyJobsSuccess) {
            final jobs = state.jobsList;
            if (jobs.isEmpty) return const Center(child: Text("لم تنشر أي وظائف حقيقية بعد"));

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index]; 
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildJobCard(context, job, state is DeleteJobLoading),
                );
              },
            );
          } else if (state is MyJobsError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, dynamic job, bool isDeleting) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // عرض نوع الوظيفة فقط (بدون Tag الـ AI)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20.r)),
                child: Text(job.type ?? "Full-time", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
              ),
              // زرار الحذف مربوط بالـ ID الحقيقي
              isDeleting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(context, job.id.toString()),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
            ],
          ),
          SizedBox(height: 12.h),
          // عنوان الوظيفة اللي أنت كتبته
          Text(job.title ?? "عنوان غير متوفر", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text("شركتك", style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
          SizedBox(height: 16.h),
          
          // عرض الموقع والراتب من الـ API
          _buildInfoRow(Icons.location_on_outlined, job.location ?? "غير محدد"),
          SizedBox(height: 8.h),
          _buildInfoRow(Icons.monetization_on_outlined, "${job.salary ?? 'غير محدد'} \$"),
          
          SizedBox(height: 12.h),
          const Divider(),
          
          // وصف الوظيفة الحقيقي
          Text("Description:", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text(job.description ?? "لا يوجد وصف لهذه الوظيفة", 
            maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700], fontSize: 13.sp)),
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
        title: const Text("حذف الوظيفة"),
        content: const Text("هل أنت متأكد من حذف هذه الوظيفة نهائياً من السيرفر؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              context.read<EmployerHomeCubit>().removeJob(id);
              Navigator.pop(c);
            }, 
            child: const Text("حذف", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}