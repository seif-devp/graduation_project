// lib/features/job_details/cubit/ai_match_state.dart
class AiMatchState {
  final int? score;
  final bool? isLoading;
  final List<String>? skills; 

  AiMatchState({
    this.score ,
    this.isLoading ,
    this.skills ,
  });
}