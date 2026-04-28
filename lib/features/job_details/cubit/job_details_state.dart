import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';

class JobDetailsState {
  final JobEntity? job;
  JobDetailsState(this.job);
}
