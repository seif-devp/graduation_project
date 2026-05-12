import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/profile/profile_seeker/data/services/profile_services.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileServices profileServices;

  ProfileCubit(this.profileServices) : super(ProfileInitial());

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await profileServices.getUserProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}