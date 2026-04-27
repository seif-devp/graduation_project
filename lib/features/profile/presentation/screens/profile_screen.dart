import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/profile/widgets/Resume.dart';
import 'package:graduation_project/features/profile/widgets/header.dart';
import 'package:graduation_project/features/profile/widgets/section_wrapper.dart';
import 'package:graduation_project/features/profile/widgets/quick_stats.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 1. Contact Information
                  Frame(
                    title: "Contact Information",
                    icon: Icons.person_outline,
                    child: Column(
                      children: [
                        Row(
                          children:  [
                            Icon(
                              Icons.email_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "ahmed.johnson@email.com",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                         SizedBox(height: 10.h),
                        Row(
                          children:  [
                            Icon(
                              Icons.phone_android_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "+1 (555) 123-4567",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 16.h),

                  // 2. My Resumes (بسطناها هنا)
                  Frame(
                    title: "My Resumes",
                    icon: Icons.description_outlined,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.upload, size: 18),
                              label: const Text("Upload"),
                            ),
                          ],
                        ),
                         SizedBox(height: 5.h),

                        // ملفات السيرة الذاتية
                        ResumeItem(
                          name: "Sarah_Johnson_Resum...",
                          date: "Uploaded 1/15/2026",
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.download_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                         SizedBox(height: 10.h),
                        ResumeItem(
                          name: "Sarah_Johnson_Resum...",
                          date: "Uploaded 1/20/2026",
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.download_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 16.h),

                  // 3. Quick Stats
                  const Frame(
                    title: "Quick Stats",
                    icon: null,
                    child: QuickStatsRow(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
