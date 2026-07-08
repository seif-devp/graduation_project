import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/settings/setting_employer/logic/repo.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/cubit/setting_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color myPrimaryBlue = Color(0xFF033B7A);

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

          final user = state.user;

          // تجهيز العرض: لو اسم الشركة موجود نعرضه، ولو لأ نعرض اسم الشخص
          final String displayTitle = (user?.companyName != null &&
                  user!.companyName!.trim().isNotEmpty)
              ? user.companyName!
              : (user?.name ?? "No Name");

          // تجهيز العرض الفرعي: لو اسم الشركة معروض فوق، نعرض تحت (الاسم • الإيميل)
          final String displaySubtitle = (user?.companyName != null &&
                  user!.companyName!.trim().isNotEmpty)
              ? "${user?.name ?? ''} • ${user?.email ?? ''}"
              : (user?.email ?? "No Email");

          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: myPrimaryBlue,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profile",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 4.h),
                  Text("Manage your company account",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70)),
                ],
              ),
              toolbarHeight: 80.h,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
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
                              backgroundColor: myPrimaryBlue.withOpacity(0.1),
                              backgroundImage: (user?.avatarUrl != null &&
                                      user!.avatarUrl!.isNotEmpty)
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                              child: (user?.avatarUrl == null ||
                                      user!.avatarUrl!.isEmpty)
                                  ? Icon(Icons.business,
                                      size: 35.sp, color: myPrimaryBlue)
                                  : null,
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🔴 التعديل هنا: عرض اسم الشركة بشكل رئيسي
                                  Text(
                                    displayTitle,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: textColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2.h),
                                  // عرض الاسم الشخصي والإيميل تحته
                                  Text(
                                    displaySubtitle,
                                    style: TextStyle(
                                        fontSize: 13.sp, color: subTextColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                            label: Text("Edit Profile",
                                style: TextStyle(color: textColor)),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // --- Company Information ---
                  _buildSection("Company Information", textColor, cardColor,
                      subTextColor, [
                    _buildRow(
                        Icons.business_outlined,
                        "Company:",
                        user?.companyName ?? "Not specified",
                        textColor,
                        subTextColor),
                    _buildRow(
                        Icons.category_outlined,
                        "Industry:",
                        user?.industry ?? "Not specified",
                        textColor,
                        subTextColor),
                    _buildRow(
                        Icons.language,
                        "Website:",
                        user?.website ?? "Not specified",
                        textColor,
                        subTextColor),
                  ]),
                  SizedBox(height: 20.h),

                  // --- Basic Information ---
                  _buildSection(
                      "Basic Information", textColor, cardColor, subTextColor, [
                    _buildRow(
                        Icons.phone_outlined,
                        "Phone:",
                        user?.phone ?? "Not specified",
                        textColor,
                        subTextColor),
                    _buildRow(
                        Icons.description_outlined,
                        "Bio:",
                        user?.bio ?? "No bio available",
                        textColor,
                        subTextColor),
                  ]),
                  SizedBox(height: 20.h),

                  // --- Appearance ---
                  Container(
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r)),
                    child: SwitchListTile(
                      title: Text(isDark ? "Dark Mode" : "Light Mode",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor)),
                      value: isDark,
                      activeColor: myPrimaryBlue,
                      onChanged: (val) =>
                          context.read<SettingsCubit>().toggleTheme(val),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // --- Logout ---
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SettingsCubit>().logout(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 50.h)),
                    child: const Text("Logout",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, Color textColor, Color cardColor,
      Color subColor, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: textColor)),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
              color: cardColor, borderRadius: BorderRadius.circular(16.r)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildRow(IconData icon, String label, String value, Color textColor,
      Color subColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(children: [
        Icon(icon, size: 20.sp, color: subColor),
        SizedBox(width: 12.w),
        Text(label, style: TextStyle(fontSize: 14.sp, color: subColor)),
        SizedBox(width: 8.w),
        Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: textColor,
                    fontWeight: FontWeight.w500))),
      ]),
    );
  }
}
