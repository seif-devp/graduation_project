import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/features/profile/profile_seeker/data/models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel user; // هنستقبل المودل هنا

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Profile",
                style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => context.push('/settingsSeeker'),
                icon: const Icon(Icons.settings, color: Colors.white),
              ),
            ],
          ),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 47,
              // لو مفيش صورة راجعة من الباك إند هنحط صورة افتراضية
              backgroundImage: NetworkImage(user.avatarUrl ?? 'https://via.placeholder.com/150'),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            user.name, // الاسم الحقيقي
            style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
             // دمجنا الـ Bio مع سنين الخبرة لو موجودة
            "${user.bio ?? 'Job Seeker'}\n${user.seekerProfile?.experienceYears ?? 0} Years Experience",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
          OutlinedButton(
            onPressed: () => context.push('/edit_profile'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}