import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/settings/settingsSekeer/data/repoSeeker.dart';
import 'package:graduation_project/features/settings/settingsSekeer/logic/entitiy.dart';

part 'setting_state.dart';

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

  void editProfile(BuildContext context) {
    context.push('/edit_profile');
  }
}
