import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/choose_one_seeker_employerpage/data/remote_source.dart';
import 'package:graduation_project/features/choose_one_seeker_employerpage/data/repo.dart';
import 'package:graduation_project/features/choose_one_seeker_employerpage/presentation/cubit/choose_state.dart';

class ApplicantDetailsCubit extends Cubit<ApplicantDetailsState> {
  ApplicantDetailsCubit()
      : super(
          const ApplicantDetailsState(),
        );

  final ApplicantDetailsRepo repo = ApplicantDetailsRepo(
    ApplicantDetailsRemoteDataSource(),
  );

  Future<void> getApplicantDetails(
    String applicationId,
  ) async {
    emit(
      state.copyWith(
        status: ApplicantDetailsStatus.loading,
      ),
    );

    final result = await repo.getApplicantDetails(
      applicationId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ApplicantDetailsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (applicantData) {
        emit(
          state.copyWith(
            status: ApplicantDetailsStatus.success,
            applicant: applicantData,
          ),
        );
      },
    );
  }
}
