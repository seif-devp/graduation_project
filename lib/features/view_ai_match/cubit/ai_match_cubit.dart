// lib/features/job_details/cubit/ai_match_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/view_ai_match/cubit/ai_match_state.dart';

class AiMatchCubit extends Cubit<AiMatchState> {
  AiMatchCubit() : super(AiMatchState());

  void fetchAiData() async {
    
    emit(AiMatchState(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    emit(AiMatchState(
      isLoading: false,
      score: 85, 
      skills: ["React", "TypeScript", "Node.js"]
    ));
  }
}