part of 'settingSeeker_cubit.dart';

class SettingsState {
  final bool isLoading;
  final SeekerEntity? user;
  final String? errorMessage;
  final bool isDarkMode;

  SettingsState({
    this.isLoading = true,
    this.user,
    this.errorMessage,
    this.isDarkMode = false,
  });

  SettingsState copyWith({
    bool? isLoading,
    SeekerEntity? user,
    String? errorMessage,
    bool? isDarkMode,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}