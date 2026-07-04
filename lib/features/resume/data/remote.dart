import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/resume/data/model.dart';

class ResumeRemoteDataSource {
  // دالة الرفع القديمة بتاعتك زي ما هي
  Future<ResumeModel> uploadResume(String filePath) async {
    final formData = FormData.fromMap({
      'File': await MultipartFile.fromFile(filePath),
    });

    final response = await DioFactory.getDio().post(
      '/api/resumes',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return ResumeModel.fromJson(response.data);
  }

  // ✅ جلب السير الذاتية
  Future<List<ResumeModel>> getResumes() async {
    final response = await DioFactory.getDio().get('/api/resumes');
    final List<dynamic> data = response.data;
    return data.map((json) => ResumeModel.fromJson(json)).toList();
  }

  // ✅ حذف سيرة ذاتية
  Future<void> deleteResume(String id) async {
    await DioFactory.getDio().delete('/api/resumes/$id');
  }

  // ✅ تعيين سيرة ذاتية كأساسية
  Future<void> setDefaultResume(String id) async {
    await DioFactory.getDio().patch('/api/resumes/$id/default');
  }
}