import 'package:graduation_project/features/joob_seeker_applications/data/paginated.dart';
import 'package:graduation_project/features/joob_seeker_applications/data/remore_source.dart';

class SeekerApplicationRepoImpl {
  final SeekerApplicationRemoteDataSource remoteDataSource;

  SeekerApplicationRepoImpl(this.remoteDataSource);

  Future<PaginatedSeekerApplicationsModel> getMyApplications({
    int page = 1,
    int pageSize = 20,
  }) async {
    return await remoteDataSource.getMyApplications(
      page: page,
      pageSize: pageSize,
    );
  }
}