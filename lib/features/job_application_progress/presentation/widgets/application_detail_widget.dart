import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplicationDetailWidget extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String salary;
  final String status;
  final String appliedDate;
  final String description;
  final List<String> requirements;

  const ApplicationDetailWidget({
    Key? key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.status,
    required this.appliedDate,
    required this.description,
    required this.requirements,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return const Color(0xFF3B82F6); // اللون الأزرق الموجود في الصورة
      case 'viewed':
        return const Color(0xFF6B7280); // اللون الرمادي الموجود في الصورة
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

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              SizedBox(height: 8.h),
              // Handle indicator
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Company and job info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        companyName.isNotEmpty
                            ? companyName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobTitle,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          companyName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status[0].toUpperCase() + status.substring(1),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Details grid
              Row(
                children: [
                  Expanded(
                    child: _DetailBox(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: location,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DetailBox(
                      icon: Icons.attach_money,
                      label: 'Salary',
                      value: salary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _DetailBox(
                      icon: Icons.calendar_today,
                      label: 'Applied',
                      value: appliedDate,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DetailBox(
                      icon: Icons.schedule,
                      label: 'Status',
                      value: status[0].toUpperCase() + status.substring(1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Description section
              Text(
                'About the Role',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[700],
                  height: 1.6.h,
                ),
              ),
              SizedBox(height: 24.h),
              // Requirements section
              Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              ...requirements.map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6.w,
                          height: 6.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D4ED8),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            req,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[700],
                              height: 1.5.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 24.h),
              // Action buttons - TODO: Add Cubit actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(
                          color: Color(0xFF1D4ED8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Withdraw',
                        style: TextStyle(
                          color: Color(0xFF1D4ED8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}

class _DetailBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: const Color(0xFF1D4ED8),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
