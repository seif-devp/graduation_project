import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/data/model.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/domain/entity.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/domain/repo.dart';

class RepoImp implements Repo {
  // We use the dio instance from your factory
  final Dio _dio = DioFactory.getDio();

  @override
  Future<List<InterviewEntity>> getInterviews() async {
    try {
      final response = await _dio.get('/api/interviews/my');

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'];

        return items.map((json) => InterviewModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch interviews');
      }
    } on DioException catch (e) {
      // Your LogInterceptor will print the details, but we catch errors here for the Cubit
      final errorMessage = e.response?.data['message'] ?? "Connection Error";
      throw Exception(errorMessage);
    }
  }

  Future<void> acceptInterview(String id) async {
    await _dio.patch('/api/interviews/$id/accepted');
  }

  @override
  Future<void> rejectInterview(String id) async {
    await _dio.patch('/api/interviews/$id/rejected');
  }

  @override
  Future<void> rescheduleInterview(String id, String proposedAt) async {
    await _dio.post(
      '/api/interviews/$id/reschedule',
      data: {'proposedAt': proposedAt},
    );
  }
}
