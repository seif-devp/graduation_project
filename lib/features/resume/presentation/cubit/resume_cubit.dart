import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/resume/data/model.dart';
import 'package:graduation_project/features/resume/data/repo.dart';

part 'resume_state.dart';

class ResumeCubit extends Cubit<ResumeState> {
  final ResumeRepository repository;

  ResumeCubit(this.repository) : super(ResumeInitial());

  Future<void> uploadResume(String filePath) async {
    emit(ResumeLoading());
    final result = await repository.uploadResume(filePath);
    result.fold(
      (failure) => emit(ResumeFailure(failure.message)),
      (resume) => emit(ResumeSuccess(resume)),
    );
  }
}