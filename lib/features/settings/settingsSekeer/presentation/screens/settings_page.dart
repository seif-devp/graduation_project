import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/settings/settingsSekeer/data/repoSeeker.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/cubit/settingSeeker_cubit.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/cubit/settingseeker_state.dart';

class SettingsPageSeeker extends StatelessWidget {
  const SettingsPageSeeker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SettingsSeekerCubit(SettingsSekeerRepository())..loadSettingsData(),
      child: BlocBuilder<SettingsSeekerCubit, SettingsState>(
        builder: (context, state) {
          final isDark = state.isDarkMode;
          final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
          final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
          final subTextColor =
              isDark ? Colors.grey[400]! : const Color(0xFF74777F);

          if (state.isLoading) {
            return Scaffold(
              backgroundColor: isDark ? const Color(0xFF121212) : primaryColor,
              body: const Center(child: loading),
            );
          }

          final user = state.user;

          return Scaffold(
            backgroundColor: isDark ? const Color(0xFF121212) : primaryColor,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Settings",
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text("Manage your account",
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.white70)),
                    SizedBox(height: 24.h),
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
                              // --- 🔴 التعديل هنا لظهور الصورة ---
                              CircleAvatar(
                                radius: 35.r,
                                backgroundColor: Colors.blue.shade100,
                                backgroundImage: (user?.avatarUrl != null &&
                                        user!.avatarUrl!.isNotEmpty)
                                    ? NetworkImage(user.avatarUrl!)
                                    : null,
                                child: (user?.avatarUrl == null ||
                                        user!.avatarUrl!.isEmpty)
                                    ? Icon(Icons.person,
                                        size: 40.sp, color: Colors.blue)
                                    : null,
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user?.name ?? "Seif",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: textColor)),
                                    Text(user?.email ?? "seif@gmail.com",
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
                                  .read<SettingsSeekerCubit>()
                                  .editProfile(context),
                              icon: Icon(Icons.edit_outlined,
                                  size: 18.sp, color: textColor),
                              label: Text("Edit Profile",
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
                    SizedBox(height: 24.h),
                    _sectionTitle("Account Information"),
                    SizedBox(height: 8.h),
                    _buildInfoCard(cardColor, [
                      _infoRow(
                          Icons.mail_outline,
                          "Email:",
                          user?.email ?? "seif@gmail.com",
                          subTextColor,
                          textColor),
                      _divider(),
                      _infoRow(
                          Icons.phone_outlined,
                          "Phone:",
                          user?.phone ?? "01017963464",
                          subTextColor,
                          textColor),
                      _divider(),
                      _infoRow(Icons.description_outlined, "Bio:",
                          user?.bio ?? "No Bio added", subTextColor, textColor),
                    ]),
                    SizedBox(height: 24.h),
                    _sectionTitle("Appearance"),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16.r)),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        title: Text(isDark ? "Dark Mode" : "Light Mode",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        secondary: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            color: Colors.blue),
                        value: isDark,
                        onChanged: (val) => context
                            .read<SettingsSeekerCubit>()
                            .toggleTheme(val),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.read<SettingsSeekerCubit>().logout(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text("Logout",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
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

  Widget _sectionTitle(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white));
  }

  Widget _buildInfoCard(Color color, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(16.r)),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color subColor,
      Color mainColor) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: subColor),
        SizedBox(width: 12.w),
        Text(label, style: TextStyle(fontSize: 14.sp, color: subColor)),
        SizedBox(width: 8.w),
        Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: mainColor,
                    fontWeight: FontWeight.w500))),
      ],
    );
  }

  Widget _divider() => Divider(height: 24.h, color: Colors.grey.shade200);
}
