import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {

  // =========================================================
  // LOAD PROFILE
  // =========================================================

  Future<Map<String, dynamic>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString('name') ?? '',

      'fullName': prefs.getString('fullName') ?? '',
      'address': prefs.getString('address') ?? '',
      'city': prefs.getString('city') ?? '',
      'state': prefs.getString('state') ?? '',
      'country': prefs.getString('country') ?? '',

      'businessName': prefs.getString('businessName') ?? '',
      'businessAddress': prefs.getString('businessAddress') ?? '',
      'businessCity': prefs.getString('businessCity') ?? '',
      'businessState': prefs.getString('businessState') ?? '',
      'businessCountry': prefs.getString('businessCountry') ?? '',

      // IMPORTANT
      'profileImage': prefs.getString('profileImage'),
    };
  }

  // =========================================================
  // SAVE PROFILE
  // =========================================================

  Future<String> saveProfile({
    required String name,

    required String fullName,
    required String address,
    required String city,
    required String state,
    required String country,

    required String businessName,
    required String businessAddress,
    required String businessCity,
    required String businessState,
    required String businessCountry,

    String? profileImage,

    required bool isBusinessAddress,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    // =======================================================
    // SAVE PROFILE IMAGE
    // =======================================================

    if (profileImage != null &&
        profileImage.trim().isNotEmpty) {

      final File imageFile = File(profileImage);

      if (await imageFile.exists()) {

        final Directory directory =
        await getApplicationDocumentsDirectory();

        final String imagePath =
            '${directory.path}/profile_image.jpg';

        final File permanentImage =
        await imageFile.copy(imagePath);

        await prefs.setString(
          'profileImage',
          permanentImage.path,
        );
      }
    }

    // =======================================================
    // SAVE PERSONAL DETAILS
    // =======================================================

    await prefs.setString(
      'name',
      name.trim(),
    );

    // =======================================================
    // SAVE PERSONAL ADDRESS
    // =======================================================

    await prefs.setString(
      'fullName',
      fullName.trim(),
    );

    await prefs.setString(
      'address',
      address.trim(),
    );

    await prefs.setString(
      'city',
      city.trim(),
    );

    await prefs.setString(
      'state',
      state.trim(),
    );

    await prefs.setString(
      'country',
      country.trim(),
    );

    // =======================================================
    // SAVE BUSINESS ADDRESS
    // =======================================================

    await prefs.setString(
      'businessName',
      businessName.trim(),
    );

    await prefs.setString(
      'businessAddress',
      businessAddress.trim(),
    );

    await prefs.setString(
      'businessCity',
      businessCity.trim(),
    );

    await prefs.setString(
      'businessState',
      businessState.trim(),
    );

    await prefs.setString(
      'businessCountry',
      businessCountry.trim(),
    );

    // =======================================================
    // SELECTED ADDRESS
    // =======================================================

    String selectedAddress;

    if (isBusinessAddress) {

      selectedAddress =
      '${businessName.trim()}, '
          '${businessAddress.trim()}, '
          '${businessCity.trim()}, '
          '${businessState.trim()}, '
          '${businessCountry.trim()}';

    } else {

      selectedAddress =
      '${fullName.trim()}, '
          '${address.trim()}, '
          '${city.trim()}, '
          '${state.trim()}, '
          '${country.trim()}';
    }

    await prefs.setString(
      'selectedAddress',
      selectedAddress,
    );

    return selectedAddress;
  }
}