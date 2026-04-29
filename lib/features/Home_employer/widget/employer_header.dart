import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Home_employer/logic/entity.dart';

class EmployerHeaderSection extends StatelessWidget {
  final EmployerHomeEntity data; // استقبال الداتا هنا

  const EmployerHeaderSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF2962FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good morning,', style: TextStyle(color: Colors.white70)),
                  Text('Sarah', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(Icons.notifications_none, color: Colors.white),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: _buildStatCard('ACTIVE JOBS', '${data.activeJobs}', Icons.work_outline)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('APPLICANTS', '${data.newApplicants}', Icons.people_outline, suffixText: 'new')),
            ],
          ),
          const SizedBox(height: 16),
          _buildWideStatCard('INTERVIEWS TODAY', '${data.interviewsToday}', Icons.calendar_today_outlined),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, {String? suffixText}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 16, color: Colors.grey),  SizedBox(width: 8.w), Text(title, style:  TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600))]),
           SizedBox(height: 12.h),
          Text(count, style:  TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWideStatCard(String title, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Icon(icon, size: 16), const SizedBox(width: 8), Text(title)]),
              Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const Text('View Calendar >', style: TextStyle(color: Color(0xFF2962FF))),
        ],
      ),
    );
  }
}