import 'package:graduation_project/features/interviews/domain/entity.dart';
import 'package:graduation_project/features/interviews/domain/repo.dart';

class RepoImp implements Repo {
  
  RepoImp();

  @override
  Future<List<InterviewEntity>> getInterviews() async {

    return [
      const InterviewEntity(
        id: '1',
        jobTitle: 'Senior Flutter Developer',
        company: 'Google',
        date: '2026-04-28',
        time: '10:00 AM',
        type: 'Technical',
        meetingLink: 'https://meet.google.com/test-link-1',
        status: 'Upcoming',
      ),
      const InterviewEntity(
        id: '2',
        jobTitle: 'Frontend Engineer',
        company: 'Microsoft',
        date: '2026-04-30',
        time: '02:00 PM',
        type: 'HR',
        meetingLink: 'https://teams.microsoft.com/test-link-2',
        status: 'Pending',
      ),
    ];
  }
}