import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// LOAD PROFILE
// ============================================================

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

// ============================================================
// SAVE PROFILE
// ============================================================

class SaveProfile extends ProfileEvent {
  final String name;

  final String fullName;
  final String address;
  final String city;
  final String state;
  final String country;

  final String businessName;
  final String businessAddress;
  final String businessCity;
  final String businessState;
  final String businessCountry;

  final String? profileImage;

  // IMPORTANT
  final bool isBusinessAddress;

  const SaveProfile({
    required this.name,

    required this.fullName,
    required this.address,
    required this.city,
    required this.state,
    required this.country,

    required this.businessName,
    required this.businessAddress,
    required this.businessCity,
    required this.businessState,
    required this.businessCountry,

    this.profileImage,

    required this.isBusinessAddress,
  });

  @override
  List<Object?> get props => [
    name,
    fullName,
    address,
    city,
    state,
    country,
    businessName,
    businessAddress,
    businessCity,
    businessState,
    businessCountry,
    profileImage,
    isBusinessAddress,
  ];
}