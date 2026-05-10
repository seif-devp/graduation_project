import 'package:graduation_project/core/networking/dio.dart';

class InterviewEndpoint {
  
  // يفضل تخلي الدالة ترجع Future عشان تقدر تستقبل الداتا في الـ UI
  Future<dynamic> getInterviewsJobID({
    required String jobId,
    int page = 1,         
    int pageSize = 20,     
  }) async {
    try {
      final response = await DioFactory.getDio().get(
        '/api/interviews/job/$jobId',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );
      
      return response.data; 

    } catch (e) {
      throw e; 
    }
  }
}