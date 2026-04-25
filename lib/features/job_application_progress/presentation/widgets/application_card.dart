import 'package:flutter/material.dart';
import 'package:graduation_project/features/job_application_progress/presentation/widgets/progressTimeLine.dart';

class ApplicationCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String logoUrl;
  final double matchPercentage;
  final String status; // 'sent', 'viewed', 'interview', 'rejected', 'accepted'
  final String appliedDate;
  final VoidCallback? onTap;

  const ApplicationCard({
    Key? key,
    required this.jobTitle,
    required this.companyName,
    required this.logoUrl,
    required this.matchPercentage,
    required this.status,
    required this.appliedDate,
    this.onTap,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
      case 'viewed':
      case 'interview':
        return const Color(0xFFF97316); // اللون البرتقالي الموجود في الصورة
      case 'rejected':
        return const Color(0xFFEF4444);
      case 'accepted':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return Icons.send;
      case 'viewed':
        return Icons.visibility;
      case 'interview':
        return Icons.calendar_today;
      case 'rejected':
        return Icons.close;
      case 'accepted':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200), // تحديد خفيف زي الصورة
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          companyName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Match Percentage Badge
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF), // لون خلفية البادج (أزرق فاتح جداً)
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome, // الأيقونة اللي كنت بتسأل عليها ✨
                          size: 16,
                          color: Color(0xFF4F46E5), // لون النجمة
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${matchPercentage.toInt()}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Progress Timeline (العداد المتعدل)
              buildProgressTimeline(status),
              
              const SizedBox(height: 24),
              
              // Bottom Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC), // رمادي فاتح جداً زي الصورة
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      size: 20,
                      color: _getStatusColor(status),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Status: ',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            children: [
                              TextSpan(
                                text: status[0].toUpperCase() + status.substring(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Applied $appliedDate',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}