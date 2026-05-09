import 'package:dartz/dartz.dart';

import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/choose_one_seeker_employerpage/data/model.dart';
import 'package:graduation_project/features/choose_one_seeker_employerpage/data/remote_source.dart';

class ApplicantDetailsRepo {

  final ApplicantDetailsRemoteDataSource
      remoteDataSource;

  ApplicantDetailsRepo(
    this.remoteDataSource,
  );

  Future<Either<Failure,
      ApplicantDetailsModel>>
      getApplicantDetails(
    String applicationId,
  ) async {

    try {

      final result =
          await remoteDataSource
              .getApplicantDetails(
        applicationId,
      );

      return Right(result);

    } catch (e) {

      return Left(
        ServerFailure(
          'Failed to load applicant details',
        ),
      );
    }
  }
}