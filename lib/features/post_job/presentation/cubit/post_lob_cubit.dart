import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/post_job/data/model_request.dart';
import 'package:graduation_project/features/post_job/data/repo_imp_.dart';
import 'post_lob_state.dart';

class PostJobCubit extends Cubit<PostJobState> {
  final JobEmployerRepositoryImpl repository;

  List<String> currentRequirements = [];

  PostJobCubit(this.repository) : super(PostJobInitial());

  void addRequirement(String value) {
    if (value.isNotEmpty) {
      currentRequirements.add(value);
      emit(PostJobRequirementsUpdated(List.from(currentRequirements)));
    }
  }

  void removeRequirement(String value) {
    currentRequirements.remove(value);
    emit(PostJobRequirementsUpdated(List.from(currentRequirements)));
  }

  Future<void> submitJobPost({
    required String title,
    required String companyName,
    required String location,
    required String salaryRange,
    required String jobType,
    required String description,
    required DateTime expiresAt,
  }) async {
    emit(PostJobLoading());

    final jobData = JobRequestModel(
      title: title,
      description: description,
      requirements: currentRequirements,
      location: location,
      salary: salaryRange,
      type: jobType,
      expiresAt: expiresAt.toUtc().toIso8601String(), 
    );

    final result = await repository.createJob(jobData);

    result.fold(
      (failure) => emit(PostJobFailure(failure.message)),
      (_) => emit(PostJobSuccess()),
    );
  }
}