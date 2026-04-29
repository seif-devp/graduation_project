import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/post_job/logic/entity.dart';
import 'package:graduation_project/features/post_job/presentation/cubit/post_lob_state.dart';

class PostJobCubit extends Cubit<PostJobState> {
  
  PostJobCubit() : super(PostJobInitial());

  List<String> currentRequirements = [];

  void addRequirement(String requirement) {
    if (requirement.trim().isNotEmpty) {
      currentRequirements.add(requirement.trim());
      emit(PostJobRequirementsUpdated(List.from(currentRequirements)));
    }
  }

  void removeRequirement(String requirement) {
    currentRequirements.remove(requirement);
    emit(PostJobRequirementsUpdated(List.from(currentRequirements)));
  }

  Future<void> submitJobPost({
    required String title,
    required String companyName,
    required String location,
    required String salaryRange,
    required String jobType,
    required String description,
  }) async {

    if (title.isEmpty || companyName.isEmpty || description.isEmpty) {
      emit(const PostJobFailure("Please fill all required fields."));
      return;
    }

    emit(PostJobLoading());

    try {
      JobPostEntity(
        title: title,
        companyName: companyName,
        location: location,
        salaryRange: salaryRange,
        jobType: jobType,
        description: description,
        requirements: currentRequirements,
      );

      await Future.delayed(const Duration(seconds: 2));
      emit(PostJobSuccess());
      
    } catch (e) {
      emit(PostJobFailure(e.toString()));
    }
  }
}