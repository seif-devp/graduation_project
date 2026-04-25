import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  void loadUnradCount()
  {
    emit(NotificationCountLoaded(unreadCount: 5));
  }
  void makeallread()
  {
    emit(NotificationCountLoaded(unreadCount: 0));
  }
}
