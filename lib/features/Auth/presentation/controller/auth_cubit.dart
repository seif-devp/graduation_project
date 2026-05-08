import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Auth/data/services/auth_services.dart';
import 'package:graduation_project/features/Auth/data/services/auth_services.dart' as DioFactory;
import 'package:graduation_project/features/Auth/data/services/background_token_refresh_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final BackgroundTokenRefreshService _tokenRefreshService =
      BackgroundTokenRefreshService();

  AuthCubit() : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
    required bool isEmployer,
  }) async {
    emit(AuthLoading());
    try {
      final resp = await DioFactory.login(email: email, password: password);
      final realRole = resp.user.role;

      // 1. لو اختار من الواجهة إنه شركة، بس الحساب طلع باحث عن عمل
      if (isEmployer == true && realRole == 0) {
        emit(AuthFailure(
            'This account belongs to a Job Seeker. Please select Job Seeker tab.'));
        return; // نوقف الكود هنا
      }

      if (isEmployer == false && realRole == 1) {
        emit(AuthFailure(
            'This account belongs to an Employer. Please select Employer tab.'));
        return;
      }

      // Start background token refresh
      _tokenRefreshService.startBackgroundRefresh(checkIntervalMinutes: 5);

      emit(AuthSuccess(role: realRole, token: resp.accessToken));
    } catch (e) {
      emit(AuthFailure('Failed to login: ${e.toString()}'));
    }
  }

  Future<void> registerJobSeeker({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int experienceYears,
    required int educationLevel,
    required List<String> skills,
    required String linkedInUrl,
    required String gitHubUrl,
  }) async {
    emit(AuthLoading());
    try {
      final resp = await DioFactory.registerJobSeeker(
        email: email,
        password: password,
        name: name,
        phone: phone,
        experienceYears: experienceYears,
        educationLevel: educationLevel,
        skills: skills,
        linkedInUrl: linkedInUrl,
        gitHubUrl: gitHubUrl,
      );

      // Start background token refresh
      _tokenRefreshService.startBackgroundRefresh(checkIntervalMinutes: 5);

      emit(AuthSuccess(role: resp.user.role, token: resp.accessToken));
    } catch (e) {
      emit(AuthFailure('Failed to register: ${e.toString()}'));
    }
  }

  Future<void> registerEmployer({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String companyName,
    required int companySize,
    required String industry,
    required String website,
  }) async {
    emit(AuthLoading());
    try {
      final resp = await DioFactory.registerEmployer(
        email: email,
        password: password,
        name: name,
        phone: phone,
        companyName: companyName,
        companySize: companySize,
        industry: industry,
        website: website,
      );

      // Start background token refresh
      _tokenRefreshService.startBackgroundRefresh(checkIntervalMinutes: 5);

      emit(AuthSuccess(role: resp.user.role, token: resp.accessToken));
    } catch (e) {
      emit(AuthFailure('Failed to register: ${e.toString()}'));
    }
  }

  /// Logout user and stop background token refresh
  Future<void> logout() async {
    _tokenRefreshService.stopBackgroundRefresh();
    await _tokenRefreshService.clearTokens();
    emit(AuthInitial());
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _tokenRefreshService.isAuthenticated();
  }

  /// Manually refresh tokens (for use when needed before scheduled refresh)
  Future<bool> refreshTokens() {
    return _tokenRefreshService.refreshToken();
  }
}
