import 'package:flutter/material.dart';
import 'package:graduation_project/features/job_application_progress/presentation/widgets/application_detail_widget.dart';

class ApplicationDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ApplicationDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String jobTitle = data['jobTitle'] as String? ?? '';
    final String companyName = data['companyName'] as String? ?? '';
    final String location = data['location'] as String? ?? 'Unknown';
    final String salary = data['salary'] as String? ?? 'Not specified';
    final String status = data['status'] as String? ?? 'sent';
    final String appliedDate = data['appliedDate'] as String? ?? '';
    final String description = data['description'] as String? ?? '';
    final List<String> requirements = (data['requirements'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ApplicationDetailWidget(
          jobTitle: jobTitle,
          companyName: companyName,
          location: location,
          salary: salary,
          status: status,
          appliedDate: appliedDate,
          description: description,
          requirements: requirements,
        ),
      ),
    );
  }
}
