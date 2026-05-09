import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/resume/data/model.dart';


class ResumeRemoteDataSource {
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
}