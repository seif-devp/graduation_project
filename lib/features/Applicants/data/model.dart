import 'package:graduation_project/features/Applicants/logic/entity.dart';

class ApplicantModel extends ApplicantEntity {
  ApplicantModel(
      {required super.id,
      required super.name,
      required super.experience,
      required super.matchScore, required super.appliedDate});
}
