import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  void loadUnradCount() {
    // No fake notification data — default to zero until backend is integrated.
    emit(NotificationCountLoaded(unreadCount: 0));
  }

  void makeallread() {
    emit(NotificationCountLoaded(unreadCount: 0));
  }
}
