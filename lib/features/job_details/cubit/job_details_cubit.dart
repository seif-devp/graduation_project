import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/job_details/cubit/job_details_state.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  JobDetailsCubit() : super(JobDetailsState(null));

  void selectJob(JobEntity job) {
    emit(JobDetailsState(job));
  }
}