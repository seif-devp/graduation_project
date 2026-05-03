import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/home_seeker/presentation/controller/job_Seeker_state.dart';

class JobSeekerCubit extends Cubit<JobState> {
  JobSeekerCubit() : super(JobInitial());

  void loadJobs() async {
    // TODO: wire this to a repository / API. For now emit empty list.
    emit(JobLoading());
    emit(const JobLoaded([]));
  }
}
