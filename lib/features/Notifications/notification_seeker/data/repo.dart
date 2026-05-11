import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/networking/errors.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/model.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/remote_data.dart';

class NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  NotificationRepository(this.remoteDataSource);

  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      return Right(await remoteDataSource.getNotifications());
    } catch (e) {
      return Left(ServerFailure('Failed to load notifications'));
    }
  }

  Future<Either<Failure, Unit>> markAsRead(String id) async {
    try { await remoteDataSource.markAsRead(id); return const Right(unit); }
    catch (e) { return Left(ServerFailure( "Update failed")); }
  }

  Future<Either<Failure, Unit>> markAllAsRead() async {
    try { await remoteDataSource.markAllAsRead(); return const Right(unit); }
    catch (e) { return Left(ServerFailure( "Update all failed")); }
  }

  Future<Either<Failure, Unit>> deleteNotification(String id) async {
    try { await remoteDataSource.deleteNotification(id); return const Right(unit); }
    catch (e) { return Left(ServerFailure( "Delete failed")); }
  }
}