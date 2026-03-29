import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/controllers/cubit/state.dart';
import 'package:graduation_project/features/Home/Data/models/jobmodel.dart';

class JobCubit extends Cubit<JobState> {
  JobCubit() : super(JobInitial());

  void loadJobs() async {
    emit(JobLoading());

    await Future.delayed(Duration(seconds: 1)); // fake API

    try {
      final jobs = [
        Job(
          title: "Senior React Developer",
          company: "TechCorp Inc.",
          location: "San Francisco, CA",
          salary: "\$120k - \$160k",
          percent: "85%",
        ),
        Job(
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
