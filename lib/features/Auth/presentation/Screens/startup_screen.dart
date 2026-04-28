import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_in_screen.dart';
import 'package:graduation_project/features/Auth/presentation/controller/auth_cubit.dart';

class StartUpScreen extends StatelessWidget {
  const StartUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
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
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    'How do you want to use the app?',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                  ),
                ),
                SizedBox(height: 30.h),
                _ChoiceCard(
                  icon: Icons.person_outline,
                  iconBackground: const Color(0xFFEAF4FF),
                  iconColor: const Color(0xFF3366FF),
                  title: "I'm a Job Seeker",
                  subtitle: 'Find your dream job with AI-powered matching',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => AuthCubit(),
                          child: const SignInScreen(initialEmployerSelected: false),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 18.h),
                _ChoiceCard(
                  icon: Icons.apartment_outlined,
                  iconBackground: const Color(0xFFF5E9FF),
                  iconColor: const Color(0xFF7B39F5),
                  title: "I'm an Employer",
                  subtitle: 'Find the perfect candidates for your team',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => AuthCubit(),
                          child: const SignInScreen(initialEmployerSelected: true),
                        ),
                      ),
                    );
                  },
                ),
                
                // شلنا الـ Spacer وحطينا SizedBox ثابت عشان الـ ScrollView ميزعلش
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
        width: double.infinity, // شلنا حرف الـ .w من هنا
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
        // كمان مفيش داعي لـ SingleChildScrollView جوه الكارد نفسه
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: iconBackground,
              child: Icon(icon, size: 38.r, color: iconColor),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
                fontFamily: 'inter',
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