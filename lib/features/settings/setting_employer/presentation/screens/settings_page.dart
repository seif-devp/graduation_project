import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/settings/setting_employer/data/repo.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/cubit/setting_cubit.dart';
import 'package:graduation_project/core/const/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SettingsCubit(SettingsRepository())..loadSettingsData(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final isDark = state.isDarkMode;
          final bgColor =
              isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FF);
          final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
          final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
          final subTextColor =
              isDark ? Colors.grey[400]! : const Color(0xFF74777F);

          if (state.isLoading) {
            return Scaffold(
                backgroundColor: bgColor, body: const Center(child: loading));
          }
          if (state.user == null) {
            return Scaffold(
              backgroundColor: bgColor,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                      SizedBox(height: 16.h),
                      Text(
                        state.errorMessage ?? "Failed to load profile data",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textColor, fontSize: 16.sp),
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<SettingsCubit>().loadSettingsData(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: const Text("Retry",
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          // ------------------------------------

          final user = state.user;

          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 236, 235, 235),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    Text("Profile",
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    Text("Manage your company account",
                        style: TextStyle(fontSize: 14.sp, color: subTextColor)),
                    SizedBox(height: 24.h),

                    // --- Profile Card ---
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35.r,
                                backgroundColor: Colors.blue.shade100,
                                child: Icon(Icons.business,
                                    size: 35.sp, color: Colors.blue),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ربط الاسم
                                    Text(user?.name ?? "No Name",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: textColor)),
                                    // ربط الإيميل
                                    Text(user?.email ?? "No Email",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: subTextColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => context
                                  .read<SettingsCubit>()
                                  .editProfile(context),
                              icon: Icon(Icons.edit_outlined,
                                  size: 18.sp, color: textColor),
                              label: Text("Edit Company Profile",
                                  style: TextStyle(color: textColor)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Company Information Section (القسم الجديد للشركة) ---
                    Text("Company Information",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(children: [
                            Icon(Icons.business_outlined,
                                size: 20.sp, color: subTextColor),
                            SizedBox(width: 12.w),
                            Text("Company:",
                                style: TextStyle(
                                    fontSize: 14.sp, color: subTextColor)),
                            SizedBox(width: 8.w),
                            Expanded(
                                child: Text(
                                    user?.companyName ?? "Not specified",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: textColor,
                                        fontWeight: FontWeight.w500))),
                          ]),
                          Divider(height: 24.h, color: Colors.grey.shade200),
                          Row(children: [
                            Icon(Icons.category_outlined,
                                size: 20.sp, color: subTextColor),
                            SizedBox(width: 12.w),
                            Text("Industry:",
                                style: TextStyle(
                                    fontSize: 14.sp, color: subTextColor)),
                            SizedBox(width: 8.w),
                            Expanded(
                                child: Text(user?.industry ?? "Not specified",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: textColor,
                                        fontWeight: FontWeight.w500))),
                          ]),
                          Divider(height: 24.h, color: Colors.grey.shade200),
                          Row(children: [
                            Icon(Icons.language,
                                size: 20.sp, color: subTextColor),
                            SizedBox(width: 12.w),
                            Text("Website:",
                                style: TextStyle(
                                    fontSize: 14.sp, color: subTextColor)),
                            SizedBox(width: 8.w),
                            Expanded(
                                child: Text(user?.website ?? "Not specified",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: textColor,
                                        fontWeight: FontWeight.w500))),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Basic Information Section (اللي كان ثابت وعدلناه) ---
                    Text("Basic Information",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(children: [
                            Icon(Icons.phone_outlined,
                                size: 20.sp, color: subTextColor),
                            SizedBox(width: 12.w),
                            Text("Phone:",
                                style: TextStyle(
                                    fontSize: 14.sp, color: subTextColor)),
                            SizedBox(width: 8.w),
                            // ربطنا التليفون أخيراً بدل الرقم الثابت!
                            Expanded(
                                child: Text(user?.phone ?? "Not specified",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: textColor,
                                        fontWeight: FontWeight.w500))),
                          ]),
                          Divider(height: 24.h, color: Colors.grey.shade200),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.description_outlined,
                                    size: 20.sp, color: subTextColor),
                                SizedBox(width: 12.w),
                                Text("Bio:",
                                    style: TextStyle(
                                        fontSize: 14.sp, color: subTextColor)),
                                SizedBox(width: 8.w),
                                // ربطنا البايو بدل النص الثابت!
                                Expanded(
                                    child: Text(user?.bio ?? "No bio available",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: textColor,
                                            fontWeight: FontWeight.w500))),
                              ]),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Appearance Section ---
                    Text("Appearance",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        title: Text(isDark ? "Dark Mode" : "Light Mode",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        subtitle: Text(
                            isDark ? "Using dark theme" : "Using light theme",
                            style: TextStyle(
                                fontSize: 13.sp, color: subTextColor)),
                        secondary: Icon(
                            isDark
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            color: Colors.blue),
                        value: isDark,
                        onChanged: (val) =>
                            context.read<SettingsCubit>().toggleTheme(val),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // --- Logout Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.read<SettingsCubit>().logout(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: Text("Logout",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
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
