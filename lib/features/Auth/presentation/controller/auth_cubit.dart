import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Auth/data/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthServices authServices = AuthServices();
  AuthCubit() : super(AuthInitial());

Future<void> login({
  required String email,
  required String password,
  required bool isEmployer, 
}) async {
  emit(AuthLoading());
  try {
    final resp = await authServices.login(email: email, password: password);
    final realRole = resp.user.role; 

    // 1. لو اختار من الواجهة إنه شركة، بس الحساب طلع باحث عن عمل
    if (isEmployer == true && realRole == 0) {
      emit(AuthFailure('This account belongs to a Job Seeker. Please select Job Seeker tab.'));
      return; // نوقف الكود هنا
    }
    
    if (isEmployer == false && realRole == 1) {
      emit(AuthFailure('This account belongs to an Employer. Please select Employer tab.'));
      return;
    }

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
      final resp=await authServices.registerJobSeeker(
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
      final resp=await authServices.registerEmployer(
        email: email,
        password: password,
        name: name,
        phone: phone,
        companyName: companyName,
        companySize: companySize,
        industry: industry,
        website: website,
      );
      emit(AuthSuccess(role: resp.user.role, token: resp.accessToken));
    } catch (e) {
      emit(AuthFailure('Failed to register: ${e.toString()}'));
    }
  }
}
