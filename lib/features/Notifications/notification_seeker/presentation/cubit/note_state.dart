import 'package:graduation_project/features/Notifications/notification_seeker/data/model.dart';

sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}
final class NotificationLoading extends NotificationState {}
final class NotificationSuccess extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationSuccess(this.notifications);
}
final class NotificationFailure extends NotificationState {
  final String message;
  NotificationFailure(this.message);
}