import 'package:graduation_project/features/settings/logic/entitiy.dart';
import 'package:graduation_project/settingsSekeer/logic/entitiy.dart';

class SettingsSekeerRepository {
  Future<SeekerEntity> getUserData() async {
    await Future.delayed(const Duration(milliseconds: 20));
    return SeekerEntity(
      name: 'Sarah Johnson',
      email: 'sarah.johnson@email.com',
      phone: '+1 (555) 123-4567',
      bio: 'Senior Frontend Developer with 5+ years experience',
      isLightMode: true,
    );
  }
}
