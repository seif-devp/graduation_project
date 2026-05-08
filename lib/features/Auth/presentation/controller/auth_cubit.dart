import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/Auth/data/services/auth_services.dart' as AuthServices;
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
      final resp = await AuthServices.login(email: email, password: password);
      final realRole = resp.user.role;

      if (isEmployer == true && realRole == 0) {
        emit(AuthFailure('This account belongs to a Job Seeker. Please select Job Seeker tab.'));
        return;
      }

      if (isEmployer == false && realRole == 1) {
        emit(AuthFailure('This account belongs to an Employer. Please select Employer tab.'));
        return;
      }

      await CacheHelper.saveData(key: 'accessToken', value: resp.accessToken);
      await CacheHelper.saveData(key: 'refreshToken', value: resp.refreshToken);
      await CacheHelper.saveData(key: 'expiresAtUtc', value: resp.expiresAtUtc);
      await CacheHelper.saveData(key: 'userRole', value: realRole);

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
      final resp = await AuthServices.registerJobSeeker(
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

      await CacheHelper.saveData(key: 'accessToken', value: resp.accessToken);
      await CacheHelper.saveData(key: 'refreshToken', value: resp.refreshToken);
      await CacheHelper.saveData(key: 'expiresAtUtc', value: resp.expiresAtUtc);
      await CacheHelper.saveData(key: 'userRole', value: resp.user.role);

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
      final resp = await AuthServices.registerEmployer(
        email: email,
        password: password,
        name: name,
        phone: phone,
        companyName: companyName,
        companySize: companySize,
        industry: industry,
        website: website,
      );

      await CacheHelper.saveData(key: 'accessToken', value: resp.accessToken);
      await CacheHelper.saveData(key: 'refreshToken', value: resp.refreshToken);
      await CacheHelper.saveData(key: 'expiresAtUtc', value: resp.expiresAtUtc);
      await CacheHelper.saveData(key: 'userRole', value: resp.user.role);

      _tokenRefreshService.startBackgroundRefresh(checkIntervalMinutes: 5);
      emit(AuthSuccess(role: resp.user.role, token: resp.accessToken));
    } catch (e) {
      emit(AuthFailure('Failed to register: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    _tokenRefreshService.stopBackgroundRefresh();
    await _tokenRefreshService.clearTokens();
    await CacheHelper.removeData(key: 'userRole');
    DioFactory.resetDio();
    emit(AuthInitial());
  }

  bool isAuthenticated() {
    return _tokenRefreshService.isAuthenticated();
  }

  Future<bool> refreshTokens() {
    return _tokenRefreshService.refreshToken();
  }
}