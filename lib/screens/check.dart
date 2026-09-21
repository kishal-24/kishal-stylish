import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';

import '../widget/bot.dart';

class Check extends StatefulWidget {
  final bool isBusinessAddress;
  final bool fromCheckout;

  const Check({
    super.key,
    this.isBusinessAddress = false,
    this.fromCheckout = false,
  });

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  bool isSaving = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // =========================================================
  // PERSONAL DETAILS
  // =========================================================

  final TextEditingController nameController = TextEditingController();

  // =========================================================
  // PERSONAL ADDRESS
  // =========================================================

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController stateController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  // =========================================================
  // BUSINESS ADDRESS
  // =========================================================

  final TextEditingController businessNameController = TextEditingController();

  final TextEditingController businessAddressController =
      TextEditingController();

  final TextEditingController businessCityController = TextEditingController();

  final TextEditingController businessStateController = TextEditingController();

  final TextEditingController businessCountryController =
      TextEditingController();

  // =========================================================
  // PROFILE IMAGE
  // =========================================================

  File? profileImage;

  final ImagePicker picker = ImagePicker();

  // =========================================================
  // INIT STATE
  // =========================================================

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(const LoadProfile());
  }

  // =========================================================
  // LOAD PROFILE DATA INTO CONTROLLERS
  // =========================================================

  Future<void> _loadProfileIntoControllers(
      ProfileLoaded state,
      ) async {
    nameController.text = state.name;

    // Personal address
    fullNameController.text = state.fullName;
    addressController.text = state.address;
    cityController.text = state.city;
    stateController.text = state.state;
    countryController.text = state.country;

    // Business address
    businessNameController.text = state.businessName;

    businessAddressController.text = state.businessAddress;

    businessCityController.text = state.businessCity;

    businessStateController.text = state.businessState;

    businessCountryController.text = state.businessCountry;

    // Profile image
    if (state.profileImage != null && state.profileImage!.isNotEmpty) {
      final file = File(state.profileImage!);
      if (await file.exists()) {
        if (!mounted) return;

        setState(() {
          profileImage = file;
        });
      }
    }
  }

  // =========================================================
  // PICK PROFILE IMAGE
  // =========================================================

  Future<void> pickImage() async {
    try {
      debugPrint('IMAGE: Opening gallery...');

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      debugPrint('IMAGE: Picker returned');

      if (image == null) {
        debugPrint('IMAGE: User cancelled');
        return;
      }

      debugPrint('IMAGE: Path = ${image.path}');

      final File selectedImage = File(image.path);

      final bool exists = await selectedImage.exists();

      debugPrint('IMAGE: File exists = $exists');

      if (!exists) {
        Fluttertoast.showToast(
          msg: 'Selected image could not be found',
        );
        return;
      }

      if (!mounted) return;

      // Copy image to permanent app directory and persist immediately,
      // so the image survives back navigation even without pressing Save.
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final String permanentPath = '${directory.path}/profile_image.jpg';
        final File permanentImage = await selectedImage.copy(permanentPath);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImage', permanentImage.path);

        if (!mounted) return;

        setState(() {
          profileImage = permanentImage;
        });

        debugPrint('IMAGE: Profile image saved permanently at ${permanentImage.path}');
      } catch (e) {
        debugPrint('IMAGE: Failed to persist image, using temp path. $e');
        if (!mounted) return;
        setState(() {
          profileImage = selectedImage;
        });
      }

      debugPrint('IMAGE: Profile image updated');

      Fluttertoast.showToast(
        msg: 'Profile image selected',
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e, stackTrace) {
      debugPrint('================================');
      debugPrint('IMAGE PICKER ERROR');
      debugPrint('$e');
      debugPrint('================================');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: 'Unable to open gallery',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // =========================================================
  // HANDLE SAVE
  // =========================================================

  void handleSave() {
    if (isSaving) {
      return;
    }

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Send data to ProfileBloc
    context.read<ProfileBloc>().add(
      SaveProfile(
        name: nameController.text.trim(),

        // Personal address
        fullName: fullNameController.text.trim(),

        address: addressController.text.trim(),

        city: cityController.text.trim(),

        state: stateController.text.trim(),

        country: countryController.text.trim(),

        // Business address
        businessName: businessNameController.text.trim(),

        businessAddress: businessAddressController.text.trim(),

        businessCity: businessCityController.text.trim(),

        businessState: businessStateController.text.trim(),

        businessCountry: businessCountryController.text.trim(),

        // Profile image
        profileImage: profileImage?.path,

        // Selected checkout address
        isBusinessAddress: widget.isBusinessAddress,
      ),
    );
  }

  // =========================================================
  // SUCCESS ANIMATION
  // =========================================================

  Future<void> showSuccessAnimation() async {
    final dialogFuture = showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future<void>.delayed(const Duration(seconds: 3), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        });

        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset(
                    'assets/DONE.json',
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Success!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Your profile has been updated.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );

    await dialogFuture;
  }

  // =========================================================
  // PROFILE FIELD
  // =========================================================

  Widget profileField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,

            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),

            suffixIcon: suffixIcon,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.grey),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.pink, width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: 15),
      ],
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    nameController.dispose();

    fullNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();

    businessNameController.dispose();
    businessAddressController.dispose();
    businessCityController.dispose();
    businessStateController.dispose();
    businessCountryController.dispose();

    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        // =====================================================
        // PROFILE LOADED
        // =====================================================

        if (state is ProfileLoaded) {
          _loadProfileIntoControllers(state);

          if (mounted) {
            setState(() {});
          }
        }

        // =====================================================
        // SAVING
        // =====================================================

        if (state is ProfileSaving) {
          if (mounted) {
            setState(() {
              isSaving = true;
            });
          }
        }

        // =====================================================
        // SAVED SUCCESSFULLY
        // =====================================================

        if (state is ProfileSaved) {
          if (mounted) {
            setState(() {
              isSaving = false;
            });
          }

          await showSuccessAnimation();

          if (!mounted) {
            return;
          }

          // From checkout
          if (widget.fromCheckout) {
            Navigator.of(context).pop(state.selectedAddress);
            return;
          }

          // Normal profile: If it's a tab in Bot, we don't necessarily need to pushAndRemoveUntil.
          // However, to keep the current behavior but ensure data is fresh, 
          // we stay with pushAndRemoveUntil but make sure the BLoC was updated.
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const bot()),
            (route) => false,
          );
        }

        // =====================================================
        // ERROR
        // =====================================================

        if (state is ProfileError) {
          if (mounted) {
            setState(() {
              isSaving = false;
            });
          }

          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
        }
      },

      // =======================================================
      // SCAFFOLD
      // =======================================================
      child: Scaffold(
        backgroundColor: Colors.white,

        // =====================================================
        // APP BAR
        // =====================================================
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),

            onPressed: () {
              if (widget.fromCheckout) {
                Navigator.of(context).pop();
                return;
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const bot()),
                (route) => false,
              );
            },
          ),

          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        // =====================================================
        // BODY
        // =====================================================
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =================================================
                // PROFILE IMAGE
                // =================================================

                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 85,
                        height: 85,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),

                        child: ClipOval(
                          child: profileImage != null
                              ? Image.file(profileImage!, fit: BoxFit.cover)
                              : Image.asset(
                                  'assets/person.jpg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),

                      Positioned(
                        right: 0,
                        bottom: 0,

                        child: GestureDetector(
                          onTap: pickImage,

                          child: Container(
                            width: 25,
                            height: 25,

                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // =================================================
                // PERSONAL DETAILS
                // =================================================
                sectionTitle('Personal Details'),

                profileField(
                  label: 'NAME',
                  controller: nameController,
                  hint: 'Enter your name',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    return null;
                  },
                ),

                // =================================================
                // PERSONAL ADDRESS
                // =================================================
                sectionTitle('Personal Address'),

                profileField(
                  label: 'FULL NAME',
                  controller: fullNameController,
                  hint: 'Enter full name',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter full name';
                    }

                    return null;
                  },
                ),

                profileField(
                  label: 'ADDRESS',
                  controller: addressController,
                  hint: 'Enter address',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter address';
                    }

                    return null;
                  },
                ),

                profileField(
                  label: 'CITY',
                  controller: cityController,
                  hint: 'Enter city',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter city';
                    }
 
                    return null;
                  },
                ),

                profileField(
                  label: 'STATE',
                  controller: stateController,
                  hint: 'Enter state',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter state';
                    }

                    return null;
                  },
                ),

                profileField(
                  label: 'COUNTRY',
                  controller: countryController,
                  hint: 'Enter country',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter country';
                    }

                    return null;
                  },
                ),

                // =================================================
                // BUSINESS ADDRESS
                // =================================================
                sectionTitle('Business Address'),

                profileField(
                  label: 'BUSINESS NAME',
                  controller: businessNameController,
                  hint: 'Enter business name',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter business name';
                    }

                    return null;
                  },
                ),

                profileField(
                  label: 'BUSINESS ADDRESS',
                  controller: businessAddressController,
                  hint: 'Enter business address',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter business address';
                    }

                    return null;
                  },
                ),

                profileField(
                  label: 'CITY',
                  controller: businessCityController,
                  hint: 'Enter business city',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter business city';
                    }

                    return null;
                  },
                ),

                profileField(
                  label: 'STATE',
                  controller: businessStateController,
                  hint: 'Enter business state',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter business state';
                    }

                    return null;
                  },
                ),

                profileField(
                  label: 'COUNTRY',
                  controller: businessCountryController,
                  hint: 'Enter business country',

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter business country';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // =================================================
                // SAVE BUTTON
                // =================================================
                SizedBox(
                  width: double.infinity,
                  height: 48,

                  child: ElevatedButton(
                    onPressed: isSaving ? null : handleSave,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,

                      disabledBackgroundColor: Colors.pink,

                      foregroundColor: Colors.white,

                      disabledForegroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),

                    child: isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,

                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
