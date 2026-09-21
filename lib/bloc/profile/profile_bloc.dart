import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({
    ProfileRepository? repository,
  })  : _repository = repository ?? ProfileRepository(),
        super(const ProfileInitial()) {
    on<LoadProfile>(_loadProfile);
    on<SaveProfile>(_saveProfile);
  }

  // =========================================================
  // LOAD PROFILE
  // =========================================================

  Future<void> _loadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());

    try {
      final data = await _repository.loadProfile();

      emit(
        ProfileLoaded(
          name: data['name']?.toString() ?? '',

          // Personal address
          fullName: data['fullName']?.toString() ?? '',
          address: data['address']?.toString() ?? '',
          city: data['city']?.toString() ?? '',
          state: data['state']?.toString() ?? '',
          country: data['country']?.toString() ?? '',

          // Business address
          businessName: data['businessName']?.toString() ?? '',
          businessAddress:
          data['businessAddress']?.toString() ?? '',
          businessCity:
          data['businessCity']?.toString() ?? '',
          businessState:
          data['businessState']?.toString() ?? '',
          businessCountry:
          data['businessCountry']?.toString() ?? '',

          // PROFILE IMAGE
          profileImage: data['profileImage']?.toString(),
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
        ),
      );
    }
  }

  // =========================================================
  // SAVE PROFILE
  // =========================================================

  Future<void> _saveProfile(
      SaveProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileSaving());

    try {
      final selectedAddress =
      await _repository.saveProfile(
        name: event.name,

        // Personal address
        fullName: event.fullName,
        address: event.address,
        city: event.city,
        state: event.state,
        country: event.country,

        // Business address
        businessName: event.businessName,
        businessAddress: event.businessAddress,
        businessCity: event.businessCity,
        businessState: event.businessState,
        businessCountry: event.businessCountry,

        // PROFILE IMAGE
        profileImage: event.profileImage,

        // Selected address
        isBusinessAddress: event.isBusinessAddress,
      );

      emit(
        ProfileSaved(
          selectedAddress: selectedAddress,
        ),
      );

      // Add this to ensure the state becomes ProfileLoaded again with the new data
      add(const LoadProfile());
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
        ),
      );
    }
  }
}