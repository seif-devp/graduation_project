import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StartUpScreen extends StatelessWidget {
  const StartUpScreen({super.key});

  // ألوان الهوية البصرية
  final Color primaryDarkBlue = const Color.fromARGB(255, 3, 59, 122);
  final Color accentCyan = const Color(0xFF00F2FE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // الخلفية الفاتحة المريحة للعين
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                Text(
                  'Welcome to JobMatch AI',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryDarkBlue, // استخدام لون البراند الأساسي
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    'How do you want to use the app?',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                  ),
                ),
                SizedBox(height: 32.h),

                // كارت الباحث عن عمل
                _ChoiceCard(
                  icon: Icons.person_outline,
                  iconBackground: primaryDarkBlue.withOpacity(0.1), // لون شفاف من الأساسي
                  iconColor: primaryDarkBlue,
                  title: "I'm a Job Seeker",
                  subtitle: 'Find your dream job with AI-powered matching',
                  onTap: () {
                    // استخدام GoRouter للتنقل للحفاظ على نظافة الكود
                    context.push('/signup', extra: {'isEmployer': false});
                  },
                ),
                SizedBox(height: 20.h),

                // كارت صاحب العمل
                _ChoiceCard(
                  icon: Icons.apartment_outlined,
                  iconBackground: primaryDarkBlue.withOpacity(0.1), // لون شفاف من الأساسي
                  iconColor: primaryDarkBlue,
                  title: "I'm an Employer",
                  subtitle: 'Find the perfect candidates for your team',
                  onTap: () {
                    // استخدام GoRouter للتنقل
                    context.push('/signup', extra: {'isEmployer': true});
                  },
                ),
                
                SizedBox(height: 60.h), 
                
                const Center(
                  child: Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                SizedBox(height: 18.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              color: Colors.black12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34.r, // كبرت الدايرة حاجة بسيطة عشان الشكل يكون متناسق أكتر
              backgroundColor: iconBackground,
              child: Icon(icon, size: 38.r, color: iconColor),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18.sp,
                color: const Color.fromARGB(255, 3, 59, 122), // نفس الكحلي
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
                fontFamily: 'inter', // تأكد إن الخط ده متضاف في pubspec.yaml
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}