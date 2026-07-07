// مسار الملف: lib/core/helpers/cache_helper.dart
import 'package:graduation_project/core/networking/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    return false;
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}

Future<String> downloadCvToTemp(String fileUrl) async {
  // 1. الرابط الثابت للسيرفر (عشان نضمن 100% إنه موجود)
  const String baseUrl = "https://smartjop.runasp.net";

  // 2. معالجة الرابط (تأكد من إزالة المسافات)
  String cleanUrl = fileUrl.trim();

  // 3. بناء الرابط الكامل:
  // لو الرابط مش بيبدأ بـ http، هنلزق الـ baseUrl فيه
  String fullUrl;
  if (cleanUrl.startsWith('http')) {
    fullUrl = cleanUrl;
  } else {
    // لو الـ baseUrl آخره / والـ fileUrl أوله /، نشيل واحدة عشان متعملش //
    String separator = cleanUrl.startsWith('/') ? '' : '/';
    fullUrl = '$baseUrl$separator$cleanUrl';
  }

  print("DEBUG: Final URL being requested -> $fullUrl");

  // 4. تحميل الملف
  final tempDir = await getTemporaryDirectory();
  final tempPath =
      '${tempDir.path}/ai_cv_${DateTime.now().millisecondsSinceEpoch}.pdf';

  // استخدمنا Dio من خلال الـ Factory عشان نضمن وجود الـ token
  await DioFactory.getDio().download(fullUrl, tempPath);

  return tempPath;
}
