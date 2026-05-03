import 'package:graduation_project/features/settings/setting_employer/logic/entitiy.dart';
class SettingsRepository
 {
  Future<UserEntity> getUserData() async {
    await Future.delayed(const Duration(milliseconds: 20));
    return UserEntity(
      name: 'Sarah Johnson',
      email: 'sarah.johnson@email.com',
      phone: '+1 (555) 123-4567',
      bio: 'Senior Frontend Developer with 5+ years experience',
      isLightMode: true,
    );
  }
}
