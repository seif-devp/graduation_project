import 'package:flutter/material.dart';
import 'package:graduation_project/features/interviews/domain/entity.dart';

class InterviewCard extends StatelessWidget {
  final InterviewEntity interview;
  const InterviewCard({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Title + Badge ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(interview.jobTitle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1D23))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(interview.status,
                    style: TextStyle(fontSize: 11,  fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Text(interview.company, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(interview.date, style: const TextStyle(fontSize: 13, color: Color(0xFF444444))),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(interview.time, style: const TextStyle(fontSize: 13, color: Color(0xFF444444))),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.videocam_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(interview.type, style: const TextStyle(fontSize: 13, color: Color(0xFF444444))),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Meeting Link', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(interview.meetingLink,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF3D5AFE), fontWeight: FontWeight.w500)),
              ],
            ),
          ),

        ],
      ),
    );
  }
}