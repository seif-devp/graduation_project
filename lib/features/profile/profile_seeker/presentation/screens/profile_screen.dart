import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/core/utils/avatar_utils.dart';
import 'package:graduation_project/features/profile/profile_seeker/data/models/profile_model.dart';
import 'package:graduation_project/features/profile/profile_seeker/data/services/profile_services.dart';
import 'package:graduation_project/features/profile/profile_seeker/presentation/cubit/profile_cubit.dart';
import 'package:graduation_project/features/profile/profile_seeker/presentation/cubit/profile_state.dart';
import 'package:graduation_project/features/profile/profile_seeker/widgets/resumes_section.dart';
import 'package:graduation_project/features/resume/data/remote.dart';
import 'package:graduation_project/features/resume/data/repo.dart';
import 'package:graduation_project/features/resume/presentation/cubit/resume_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit(ProfileServices())..fetchUserProfile()),
        BlocProvider(create: (context) => ResumeCubit(ResumeRepository(ResumeRemoteDataSource()))..getResumes()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FE),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) return const Center(child: loading);
            if (state is ProfileLoaded) {
              final user = state.profile;
              return Column(
                children: [
                  _buildHeader(user, context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                      child: Column(
                        children: [
                          _buildSection("Contact Information", [
                            _infoRow(Icons.email_rounded, user.email),
                            SizedBox(height: 12.h),
                            _infoRow(Icons.phone_rounded, user.phone?.isNotEmpty == true ? user.phone! : "No phone provided"),
                          ]),
                          SizedBox(height: 16.h),
                          _buildSection("Professional Summary", [
                            Text(user.bio ?? "Flutter Developer passionate about building great UI/UX.",
                                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700, height: 1.6)),
                          ]),
                          SizedBox(height: 16.h),
                          _buildSection("My Resumes", [
                            const ResumesSection(),
                          ]),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ProfileModel user, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Profile", style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () => context.push('/settingsSeeker'),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          CircleAvatar(
            radius: 45.r,
            backgroundColor: Colors.white,
            child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(user.avatarUrl!, fit: BoxFit.cover, width: 90.r, height: 90.r),
                  )
                : Icon(Icons.person, size: 60.r, color: primaryColor),
          ),
          SizedBox(height: 12.h),
          Text(user.name, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 4.h),
          Text(user.email, style: TextStyle(fontSize: 13.sp, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black87)),
          Divider(height: 24.h),
          ...children,
        ]),
      );

  Widget _infoRow(IconData icon, String text) => Row(children: [
        Icon(icon, size: 18, color: primaryColor),
        SizedBox(width: 10.w),
        Text(text, style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700))
      ]);
}