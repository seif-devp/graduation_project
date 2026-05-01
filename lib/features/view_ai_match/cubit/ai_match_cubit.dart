// lib/features/job_details/cubit/ai_match_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/view_ai_match/cubit/ai_match_state.dart';

class AiMatchCubit extends Cubit<AiMatchState> {
  AiMatchCubit() : super(AiMatchState());

  void fetchAiData() async {
    // TODO: fetch AI match data from backend. Currently no fake/sample data.
    emit(AiMatchState(isLoading: false));
  }
}
