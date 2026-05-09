import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Applicants/logic/entity.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_cubit.dart';
import 'package:graduation_project/features/Applicants/widgets/schedule_inerview_dialog.dart';

// تأكد من عمل import لملف الديالوج

class ApplicantCard extends StatelessWidget {
  final ApplicantEntity applicant;

  const ApplicantCard({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF),
                    borderRadius: BorderRadius.circular(10)),
                child: Text('${applicant.matchScore}% Match',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade50,
                child:
                    Icon(Icons.person, size: 40, color: Colors.blue.shade200)),
            const SizedBox(height: 12),
            Text(applicant.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${applicant.experience} years experience',
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            _buildInfoBox('Applied', applicant.appliedDate),
            const SizedBox(height: 10),
            _buildScoreBox('Match Score', applicant.matchScore),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleButton(Icons.thumb_down_alt_outlined, Colors.red,
                    () => context.read<ApplicantsCubit>().swipeLeft()),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ScheduleInterviewDialog(applicant: applicant),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_month_outlined, size: 18),
                        SizedBox(width: 6),
                        Text('Interview', style: const TextStyle(fontSize: 13))
                      ],
                    ),
                  ),
                ),
                _buildCircleButton(Icons.thumb_up_alt_outlined, Colors.green,
                    () => context.read<ApplicantsCubit>().swipeRight()),
              ],
            ),
            const SizedBox(height: 15),
            const Text('Swipe left to reject • Swipe right to shortlist',
                style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ]),
    );
  }

  Widget _buildScoreBox(String title, int score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(
              child: LinearProgressIndicator(
                  value: score / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF1E40AF)))),
          const SizedBox(width: 10),
          Text('$score%',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ]),
      ]),
    );
  }

  Widget _buildCircleButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 22)));
  }
}
