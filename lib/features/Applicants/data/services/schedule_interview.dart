import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/Applicants/logic/entity.dart';

class ScheduleInterview {
  
  Future<void> schedule({
    required ApplicantEntity applicant,
    required String scheduledDateIso,
    required String interviewMode,
    required String meetingLink,
  }) async {
    try {
      await DioFactory.getDio().post(
        '/api/interviews',
        data: {
          'applicationId': applicant.id, 
          'scheduledAt': scheduledDateIso, 
          'mode': interviewMode,
          'interviewLink': meetingLink,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}