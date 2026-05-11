part of 'notification_Employer_cubit.dart';

sealed class NotificationStateEmployer extends Equatable {
  const NotificationStateEmployer();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationStateEmployer {}
final class NotificationLoading extends NotificationStateEmployer {}
final class NotificationFailed extends NotificationStateEmployer {
  final String message;
  const NotificationFailed(this.message);
  @override
  List<Object> get props => [message];
}
class NotificationCountLoaded extends NotificationStateEmployer {
  final int unreadCount;
  final List<NotificationModel> notifications;
  const NotificationCountLoaded({
    required this.unreadCount,
    required this.notifications,
  });
  @override
  List<Object> get props => [unreadCount, notifications];
}