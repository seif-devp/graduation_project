import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/job_application_progress/data/repo.dart';
import 'package:graduation_project/features/job_application_progress/presentation/cubit/application_progress_state.dart';

class ApplicationProgressCubit extends Cubit<ApplicationProgressState> {
  final SeekerApplicationRepoImpl repo;
  int _currentPage = 1;
  final int _pageSize = 20;

  ApplicationProgressCubit(this.repo) : super(ApplicationProgressInitial());

  Future<void> getMyApplications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      emit(ApplicationProgressLoading());
    } else {
      if (state is ApplicationProgressLoaded && (state as ApplicationProgressLoaded).hasReachedMax) {
        return;
      }
      if (state is! ApplicationProgressLoaded) {
        emit(ApplicationProgressLoading());
      }
    }

    try {
      final response = await repo.getMyApplications(
        page: _currentPage,
        pageSize: _pageSize,
      );

      final newApplications = response.items;
      final isLastPage = _currentPage >= response.totalPages;

      if (state is ApplicationProgressLoaded && !refresh) {
        final currentApplications = (state as ApplicationProgressLoaded).applications;
        emit(ApplicationProgressLoaded(
          applications: currentApplications + newApplications,
          hasReachedMax: isLastPage,
        ));
      } else {
        emit(ApplicationProgressLoaded(
          applications: newApplications,
          hasReachedMax: isLastPage,
        ));
      }
      _currentPage++;
    } catch (e) {
      emit(ApplicationProgressError(e.toString()));
    }
  }
}
