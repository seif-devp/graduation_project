part of 'notification_Employer_cubit.dart';

sealed class NotificationStateEmployer extends Equatable {
  const NotificationStateEmployer();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationStateEmployer {}
final class NotificationLoading extends NotificationStateEmployer{}
class NotificationCountLoaded extends NotificationStateEmployer {
  final int unreadCount;
  NotificationCountLoaded({required this.unreadCount});
}