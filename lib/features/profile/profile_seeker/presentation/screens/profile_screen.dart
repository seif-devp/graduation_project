import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/profile/profile_seeker/data/models/profile_model.dart';
import 'package:graduation_project/features/profile/profile_seeker/data/services/profile_services.dart';
import 'package:graduation_project/features/profile/profile_seeker/presentation/cubit/profile_cubit.dart';
import 'package:graduation_project/features/profile/profile_seeker/presentation/cubit/profile_state.dart';
import 'package:graduation_project/features/settings/settingsSekeer/logic/entitiy.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileServices())..fetchUserProfile(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: loading);
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message,
                        style: const TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().fetchUserProfile(),
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            } else if (state is ProfileLoaded) {
              final user = state.profile;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileHeader(user: user),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Frame(
                            title: "Contact Information",
                            icon: Icons.person_outline,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.email_outlined,
                                        size: 20, color: Colors.grey),
                                    SizedBox(width: 10.w),
                                    Text(user.email,
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                if (user.phone != null &&
                                    user.phone!.isNotEmpty)
                                  Row(
                                    children: [
                                      const Icon(Icons.phone_android_outlined,
                                          size: 20, color: Colors.grey),
                                      SizedBox(width: 10.w),
                                      Text(user.phone!,
                                          style: const TextStyle(
                                              color: Colors.black87)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          if (user.seekerProfile != null &&
                              user.seekerProfile!.skills.isNotEmpty) ...[
                            Frame(
                              title: "Skills",
                              icon: Icons.star_border,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: user.seekerProfile!.skills
                                    .map((skill) => Chip(
                                          label: Text(skill),
                                          backgroundColor:
                                              const Color(0xFF2563EB)
                                                  .withOpacity(0.1),
                                        ))
                                    .toList(),
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
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
                                ResumeItem(
                                  name: "Sarah_Johnson_Resum...",
                                  date: "Uploaded 1/15/2026",
                                  actions: [
                                    IconButton(
                                      icon: const Icon(Icons.download_outlined,
                                          color: Colors.grey),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.redAccent),
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
                                      icon: const Icon(Icons.download_outlined,
                                          color: Colors.grey),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.redAccent),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
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
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ProfileModel user;

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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold),
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
              backgroundImage: NetworkImage(
                  user.avatarUrl ?? 'https://via.placeholder.com/150'),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            user.name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            "${user.bio ?? 'Job Seeker'}\n${user.seekerProfile?.experienceYears ?? 0} Years Experience",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
         OutlinedButton(
            onPressed: () async {
              final seekerData = SeekerEntity(
                name: user.name,
                email: user.email,
                phone: user.phone ?? '',
                bio: user.bio ?? '',
                isLightMode: true,
              );

              final didUpdate = await context.push('/edit_profile', extra: seekerData);
              
              if (didUpdate == true) {
                // ignore: use_build_context_synchronously
                context.read<ProfileCubit>().fetchUserProfile();
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white54),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Edit Profile",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        stat("12", "Applications"),
        stat("3", "Interviews"),
        stat("8", "Saved Jobs"),
      ],
    );
  }
}

Widget stat(String n, String t) => Column(
      children: [
        Text(
          n,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2563EB),
          ),
        ),
        Text(t, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );

class ResumeItem extends StatelessWidget {
  final String name, date;
  final List<Widget> actions;

  const ResumeItem({
    super.key,
    required this.name,
    required this.date,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.article_outlined, color: Color(0xFF2563EB)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(date,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

class Frame extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;

  const Frame(
      {super.key,
      required this.title,
      this.icon,
      required this.child,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                if (icon != null) Icon(icon, color: const Color(0xFF2563EB)),
                SizedBox(width: 8.w),
                Text(title,
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ]),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }
}
