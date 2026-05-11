import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/model.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/remote_data.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/repo.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/presentation/cubit/note_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationInitial());

  // ✅ factory constructor عشان يبقى سهل تعمله في أي مكان
  factory NotificationCubit.create() {
    return NotificationCubit(
      NotificationRepository(NotificationRemoteDataSource()),
    );
  }

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    final result = await repository.getNotifications();
    result.fold(
      (failure) => emit(NotificationFailure(failure.message)),
      (notifications) => emit(NotificationSuccess(notifications)),
    );
  }

  // ✅ للـ shell layout
  void loadUnradCount() => fetchNotifications();

  Future<void> markAsRead(String id) async {
    final currentState = state;
    if (currentState is NotificationSuccess) {
      final newList = currentState.notifications
          .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
          .toList();
      emit(NotificationSuccess(newList));
      await repository.markAsRead(id);
    }
  }

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is NotificationSuccess) {
      final newList = currentState.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      emit(NotificationSuccess(newList));
      await repository.markAllAsRead();
    }
  }

  Future<void> deleteNotification(String id) async {
    final currentState = state;
    if (currentState is NotificationSuccess) {
      final newList = currentState.notifications
          .where((n) => n.id != id)
          .toList();
      emit(NotificationSuccess(newList));
      await repository.deleteNotification(id);
    }
  }

  int getUnreadCount() {
    if (state is NotificationSuccess) {
      return (state as NotificationSuccess)
          .notifications
          .where((n) => !n.isRead)
          .length;
    }
    return 0;
  }
}