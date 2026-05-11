import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/model.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/remote_data.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/repo.dart';

part 'notification_Employer_state.dart';

class NotificationCubitEmployer extends Cubit<NotificationStateEmployer> {
  final NotificationRepository repository;

  NotificationCubitEmployer()
      : repository = NotificationRepository(NotificationRemoteDataSource()),
        super(NotificationInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    final result = await repository.getNotifications();
    result.fold(
      (failure) => emit(NotificationFailed(failure.message)),
      (notifications) {
        final unread = notifications.where((n) => !n.isRead).length;
        emit(NotificationCountLoaded(
          unreadCount: unread,
          notifications: notifications,
        ));
      },
    );
  }

  void loadUnradCount() => fetchNotifications();

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is NotificationCountLoaded) {
      final newList = currentState.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      emit(NotificationCountLoaded(unreadCount: 0, notifications: newList));
      await repository.markAllAsRead();
    }
  }

  Future<void> deleteNotification(String id) async {
    final currentState = state;
    if (currentState is NotificationCountLoaded) {
      final newList = currentState.notifications
          .where((n) => n.id != id)
          .toList();
      final unread = newList.where((n) => !n.isRead).length;
      emit(NotificationCountLoaded(
        unreadCount: unread,
        notifications: newList,
      ));
      await repository.deleteNotification(id);
    }
  }
}