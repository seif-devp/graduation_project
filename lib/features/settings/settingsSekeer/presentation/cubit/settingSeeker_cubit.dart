import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/settings/settingsSekeer/data/repoSeeker.dart';
import 'package:graduation_project/features/settings/settingsSekeer/logic/entitiy.dart';

part 'settingSeeker_state.dart';

class SettingsSeekerCubit extends Cubit<SettingsState> {
  final SettingsSekeerRepository repository;

  SettingsSeekerCubit(this.repository) : super(SettingsState());

  void loadSettingsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await repository.getUserData();
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: 'Failed to load data'));
    }
  }

  void toggleTheme(bool isDark) {
    emit(state.copyWith(isDarkMode: isDark));
  }

  void logout(BuildContext context) {
    context.go('/login');
  }

  void editProfile(BuildContext context) async {
    final didUpdate = await context.push('/edit_profile', extra: state.user);
    
    if (didUpdate == true) {
      loadSettingsData(); 
    }
  }

  // 2. ضيف الدالة الجديدة دي للحفظ
  Future<void> saveProfileChanges({
    required String name,
    required String phone,
    required String bio,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.updateBasicProfile(name: name, phone: phone, bio: bio);

      emit(state.copyWith(isLoading: false));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully!')));

      // نرجعه للشاشة اللي قبلها ونبعت true عشان يعمل ريفريش
      context.pop(true);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
