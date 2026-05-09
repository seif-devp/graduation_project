import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/joob_seeker_applications/data/model.dart';
import 'package:graduation_project/features/joob_seeker_applications/data/repo.dart';


part 'seeker_application_state.dart';

class SeekerApplicationCubit extends Cubit<SeekerApplicationState> {
  final SeekerApplicationRepoImpl repo;

  SeekerApplicationCubit(this.repo)
      : super(SeekerApplicationInitial());

  List<SeekerApplicationModel> applications = [];

  int currentPage = 1;
  int totalPages = 1;

  bool isLoadingMore = false;

  Future<void> getMyApplications({
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) {
        if (isLoadingMore) return;

        isLoadingMore = true;

        emit(SeekerApplicationPaginationLoading());
      } else {
        emit(SeekerApplicationLoading());

        currentPage = 1;

        applications.clear();
      }

      final result = await repo.getMyApplications(
        page: currentPage,
      );

      totalPages = result.totalPages;

      applications.addAll(result.items);

      if (currentPage < totalPages) {
        currentPage++;
      }

      emit(SeekerApplicationSuccess());

      isLoadingMore = false;
    } catch (e) {
      emit(
        SeekerApplicationError(
          e.toString(),
        ),
      );
    }
  }
}