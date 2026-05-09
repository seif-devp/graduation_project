import 'package:dio/dio.dart';
import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/joob_seeker_applications/data/paginated.dart';

class SeekerApplicationRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  Future<PaginatedSeekerApplicationsModel> getMyApplications({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await dio.get(
      '/api/applications/my',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    return PaginatedSeekerApplicationsModel.fromJson(response.data);
  }
}