
import 'package:graduation_project/features/job_list/domain/job_entity.dart';

abstract class Jobrepo {
  Future<List<JobEntity>> fetchJob();
}
