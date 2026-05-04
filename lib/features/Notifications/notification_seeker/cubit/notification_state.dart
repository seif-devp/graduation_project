part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}
final class NotificationLoading extends NotificationState{}
class NotificationCountLoaded extends NotificationState {
  final int unreadCount;
  NotificationCountLoaded({required this.unreadCount});
}