import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Home/presentation/controller/job_Seeker_state.dart';
import 'package:graduation_project/features/Home/Data/models/jobmodel.dart';

class JobSeekerCubit extends Cubit<JobState> {
  JobSeekerCubit() : super(JobInitial());

  void loadJobs() async {
    emit(JobLoading());

    await Future.delayed(Duration(seconds: 1)); // fake API

    try {
      final jobs = [
        JobModelHome(
          title: "Senior React Developer",
          company: "TechCorp Inc.",
          location: "San Francisco, CA",
          salary: "\$120k - \$160k",
          percent: "85%",
        ),
        JobModelHome(
          title: "Frontend Engineer",
          company: "StartupXYZ",
          location: "Remote",
          salary: "\$100k - \$140k",
          percent: "92%",
        ),
      ];

      emit(JobLoaded(jobs));
    } catch (e) {
      emit(JobError("Failed to load jobs"));
    }
  }
}
