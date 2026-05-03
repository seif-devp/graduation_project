import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/settings/setting_employer/data/repo.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/cubit/setting_cubit.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(SettingsRepository())..loadSettingsData(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final isDark = state.isDarkMode;
          final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FF);
          final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
          final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
          final subTextColor = isDark ? Colors.grey[400]! : const Color(0xFF74777F);

          if (state.isLoading) {
            return Scaffold(backgroundColor: bgColor, body: const Center(child: loading));
          }

          return Scaffold(
            backgroundColor: bgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    Text("Settings", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: textColor)),
                    Text("Manage your account", style: TextStyle(fontSize: 14.sp, color: subTextColor)),
                    SizedBox(height: 24.h),

                    // --- Profile Card ---
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35.r,
                                backgroundColor: Colors.blue.shade100,
                                child: Icon(Icons.person, size: 40.sp, color: Colors.blue),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.user?.name ?? "Sarah Johnson", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: textColor)),
                                    Text(state.user?.email ?? "sarah.johnson@email.com", style: TextStyle(fontSize: 14.sp, color: subTextColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => context.read<SettingsCubit>().editProfile(context),
                              icon: Icon(Icons.person_outline, size: 18.sp, color: textColor),
                              label: Text("Edit Profile", style: TextStyle(color: textColor)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Account Information Section ---
                    Text("Account Information", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: textColor)),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          Row(children: [
                            Icon(Icons.mail_outline, size: 20.sp, color: subTextColor),
                            SizedBox(width: 12.w),
                            Text("Email:", style: TextStyle(fontSize: 14.sp, color: subTextColor)),
                            SizedBox(width: 8.w),
                            Expanded(child: Text(state.user?.email ?? "sarah.johnson@email.com", style: TextStyle(fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500))),
                          ]),
                          Divider(height: 24.h, color: Colors.grey.shade200),
                          Row(children: [
                            Icon(Icons.phone_outlined, size: 20.sp, color: subTextColor),
                            SizedBox(width: 12.w),
                            Text("Phone:", style: TextStyle(fontSize: 14.sp, color: subTextColor)),
                            SizedBox(width: 8.w),
                            Expanded(child: Text("+1 (555) 123-4567", style: TextStyle(fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500))),
                          ]),
                          Divider(height: 24.h, color: Colors.grey.shade200),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Icon(Icons.description_outlined, size: 20.sp, color: subTextColor),
                            SizedBox(width: 12.w),
                            Text("Bio:", style: TextStyle(fontSize: 14.sp, color: subTextColor)),
                            SizedBox(width: 8.w),
                            Expanded(child: Text("Senior Frontend Developer with 5+ years experience", style: TextStyle(fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500))),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Appearance Section ---
                    Text("Appearance", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: textColor)),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                        title: Text(isDark ? "Dark Mode" : "Light Mode", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: textColor)),
                        subtitle: Text(isDark ? "Using dark theme" : "Using light theme", style: TextStyle(fontSize: 13.sp, color: subTextColor)),
                        secondary: Icon(isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined, color: Colors.blue),
                        value: isDark,
                        onChanged: (val) => context.read<SettingsCubit>().toggleTheme(val),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Support Section ---
                    Text("Support", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: textColor)),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: () => context.read<SettingsCubit>(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.help_outline, color: textColor),
                            SizedBox(width: 12.w),
                            Text("Report an Issue", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: textColor)),
                            const Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 14.sp, color: subTextColor),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // --- Logout Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton.icon(
                        onPressed: () => context.read<SettingsCubit>().logout(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: Text("Logout", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}