import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
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

  const ProfileLoaded({
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
    required this.profileImage,
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
  ];
}

class ProfileSaving extends ProfileState {
  const ProfileSaving();
}

class ProfileSaved extends ProfileState {
  final String selectedAddress;

  const ProfileSaved({
    required this.selectedAddress,
  });

  @override
  List<Object?> get props => [selectedAddress];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}