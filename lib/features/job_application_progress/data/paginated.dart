import 'package:graduation_project/features/job_application_progress/data/model.dart';



class PaginatedSeekerApplicationsModel {
  final List<SeekerApplicationModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginatedSeekerApplicationsModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedSeekerApplicationsModel.fromJson(
      Map<String, dynamic> json) {
    return PaginatedSeekerApplicationsModel(
      items: List<SeekerApplicationModel>.from(
        json['items'].map(
          (x) => SeekerApplicationModel.fromJson(x),
        ),
      ),
      totalCount: json['totalCount'],
      page: json['page'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
    );
  }
}