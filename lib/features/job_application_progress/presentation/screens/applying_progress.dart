import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/job_application_progress/presentation/widgets/application_card.dart';

class ApplicationProgressScreen extends StatelessWidget {
  const ApplicationProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Applications',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track your job applications',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  _buildStatsBar(context),
                ],
              ),
            ),
            // Applications list - TODO: Replace with BlocBuilder
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  // TODO: Wrap with BlocBuilder<ApplicationProgressCubit, ApplicationProgressState>
                  // TODO: Add loading state
                  // TODO: Add error state
                  // TODO: Map state.applications to ApplicationCard widgets
                  ApplicationCard(
                    jobTitle: 'Senior React Developer',
                    companyName: 'TechCorp Inc.',
                    logoUrl: 'assets/techcorp.png',
                    matchPercentage: 85,
                    status: 'interview',
                    appliedDate: '1/29/2026',
                    onTap: () {
                      // TODO: Navigate to application details
                    },
                  ),
                  ApplicationCard(
                    jobTitle: 'Frontend Engineer',
                    companyName: 'StartupXYZ',
                    logoUrl: 'assets/startup.png',
                    matchPercentage: 92,
                    status: 'viewed',
                    appliedDate: '1/28/2026',
                    onTap: () {
                      // TODO: Navigate to application details
                    },
                  ),
                  ApplicationCard(
                    jobTitle: 'UI/UX Designer',
                    companyName: 'Design Studio Co',
                    logoUrl: 'assets/design.png',
                    matchPercentage: 78,
                    status: 'sent',
                    appliedDate: '1/27/2026',
                    onTap: () {
                      // TODO: Navigate to application details
                    },
                  ),
                  ApplicationCard(
                    jobTitle: 'Backend Developer',
                    companyName: 'Enterprise Systems',
                    logoUrl: 'assets/enterprise.png',
                    matchPercentage: 88,
                    status: 'rejected',
                    appliedDate: '1/25/2026',
                    onTap: () {
                      // TODO: Navigate to application details
                    },
                  ),
                  ApplicationCard(
                    jobTitle: 'Full Stack Developer',
                    companyName: 'Tech Innovations',
                    logoUrl: 'assets/techinnovate.png',
                    matchPercentage: 95,
                    status: 'accepted',
                    appliedDate: '1/24/2026',
                    onTap: () {
                      // TODO: Navigate to application details
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            icon: Icons.send,
            label: 'Sent',
            count: '12',
            // TODO: Replace with state.sentCount
          ),
          _StatItem(
            icon: Icons.visibility,
            label: 'Viewed',
            count: '8',
            // TODO: Replace with state.viewedCount
          ),
          _StatItem(
            icon: Icons.calendar_today,
            label: 'Interviews',
            count: '3',
            // TODO: Replace with state.interviewCount
          ),
          _StatItem(
            icon: Icons.check_circle,
            label: 'Accepted',
            count: '1',
            // TODO: Replace with state.acceptedCount
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF1D4ED8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
