import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/settings/setting_employer/data/repo.dart';
import 'package:graduation_project/features/settings/setting_employer/logic/entitiy.dart';

part 'setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit(this.repository) : super(SettingsState());

  // جلب البيانات عند فتح الإعدادات
  void loadSettingsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await repository.getUserData();
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // تحديث البيانات الأساسية (الاسم، التليفون، البايو)
  Future<void> saveBasicInfo({
    required String name,
    required String phone,
    required String bio,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.updateBasicProfile(name: name, phone: phone, bio: bio);
      loadSettingsData(); // ريفريش للداتا
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Basic Info Updated!')));
      context.pop(true);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // تحديث بيانات الشركة (الاسم، الحجم، الصناعة، الموقع)
  Future<void> saveCompanyInfo({
    required String companyName,
    required String companySize,
    required String industry,
    required String website,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.updateEmployerProfile(
        companyName: companyName,
        companySize: companySize,
        industry: industry,
        website: website,
      );
      loadSettingsData();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Company Info Updated!')));
      context.pop(true);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void toggleTheme(bool isDark) {
    emit(state.copyWith(isDarkMode: isDark));
  }

  void logout(BuildContext context) {
    context.go('/login');
  }

  void editProfile(BuildContext context) async {
    final didUpdate =
        await context.push('/edit_profile_employer', extra: state.user);

    if (didUpdate == true) {
      loadSettingsData();
    }
  }
}
