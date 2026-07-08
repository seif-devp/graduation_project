import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/settings/setting_employer/data/entitiy.dart';
import 'package:graduation_project/features/settings/setting_employer/logic/repo.dart';


part 'setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit(this.repository) : super(SettingsState());

  void loadSettingsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await repository.getUserData();
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // 🔴 دالة واحدة بتحفظ كله (الأساسي + الشركة + الصورة)
  Future<void> saveFullProfile({
    required String name,
    required String phone,
    required String bio,
    required String companyName,
    required String companySize,
    required String industry,
    required String website,
    String? avatarFilePath,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      // 1. تحديث البيانات الأساسية
      await repository.updateBasicProfile(name: name, phone: phone, bio: bio);
      
      // 2. تحديث بيانات الشركة
      await repository.updateEmployerProfile(
        companyName: companyName,
        companySize: companySize,
        industry: industry,
        website: website,
      );

      // 3. رفع الصورة لو اتغيرت
      if (avatarFilePath != null && avatarFilePath.isNotEmpty) {
        await repository.updateAvatar(avatarFilePath);
      }

      loadSettingsData(); 
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated Successfully!')));
      context.pop(true);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void toggleTheme(bool isDark) {
    emit(state.copyWith(isDarkMode: isDark));
  }

  void logout(BuildContext context) {
    context.go('/login');
  }

  void editProfile(BuildContext context) async {
    final didUpdate = await context.push('/edit_profile_employer', extra: state.user);

    if (didUpdate == true) {
      loadSettingsData();
    }
  }
}