import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_Employer_state.dart';

class NotificationCubitEmployer extends Cubit<NotificationStateEmployer> {
  NotificationCubitEmployer() : super(NotificationInitial());
  void loadUnradCount() {
    // No fake notification data — default to zero until backend is integrated.
    emit(NotificationCountLoaded(unreadCount: 0));
  }

  void makeallread() {
    emit(NotificationCountLoaded(unreadCount: 0));
  }
}
