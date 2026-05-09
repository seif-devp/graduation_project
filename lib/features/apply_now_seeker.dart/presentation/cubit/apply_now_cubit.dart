import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'apply_now_state.dart';

class ApplyNowCubit extends Cubit<ApplyNowState> {
  ApplyNowCubit() : super(ApplyNowInitial());
}
