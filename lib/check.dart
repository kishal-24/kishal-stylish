import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/bot.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  final TextEditingController nameController = TextEditingController();

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController stateController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  // Business address
  final TextEditingController businessNameController = TextEditingController();

  final TextEditingController businessAddressController =
      TextEditingController();

  final TextEditingController businessCityController = TextEditingController();

  final TextEditingController businessStateController = TextEditingController();

  final TextEditingController businessCountryController =
      TextEditingController();

  File? profileImage;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImage');
    if (!mounted) return;

    setState(() {
      if (imagePath != null && imagePath.isNotEmpty) {
        profileImage = File(imagePath);
      }
      nameController.text = prefs.getString('name') ?? '';



      // Personal address
      fullNameController.text = prefs.getString('fullName') ?? '';

      addressController.text = prefs.getString('address') ?? '';

      cityController.text = prefs.getString('city') ?? '';

      stateController.text = prefs.getString('state') ?? '';

      countryController.text = prefs.getString('country') ?? '';

      businessNameController.text = prefs.getString('businessName') ?? '';

      businessAddressController.text = prefs.getString('businessAddress') ?? '';

      businessCityController.text = prefs.getString('businessCity') ?? '';

      businessStateController.text = prefs.getString('businessState') ?? '';

      businessCountryController.text = prefs.getString('businessCountry') ?? '';
    });
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null && mounted) {
      setState(() {
        profileImage = File(image.path);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', image.path);
    }
  }

  Future<String?> saveProfile() async {
    if (mounted) {
      setState(() {
        isSaving = true;
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('name', nameController.text.trim());



      await prefs.setString('fullName', fullNameController.text.trim());

      await prefs.setString('address', addressController.text.trim());

      await prefs.setString('city', cityController.text.trim());

      await prefs.setString('state', stateController.text.trim());

      await prefs.setString('country', countryController.text.trim());

      // =========================
      // BUSINESS ADDRESS
      // =========================

      await prefs.setString('businessName', businessNameController.text.trim());

      await prefs.setString(
        'businessAddress',
        businessAddressController.text.trim(),
      );

      await prefs.setString('businessCity', businessCityController.text.trim());

      await prefs.setString(
        'businessState',
        businessStateController.text.trim(),
      );

      await prefs.setString(
        'businessCountry',
        businessCountryController.text.trim(),
      );

      // =========================
      // SELECT ADDRESS
      // =========================

      String selectedAddress;

      if (widget.isBusinessAddress) {
        selectedAddress =
            '${businessNameController.text.trim()}, '
            '${businessAddressController.text.trim()}, '
            '${businessCityController.text.trim()}, '
            '${businessStateController.text.trim()}, '
            '${businessCountryController.text.trim()}';
      } else {
        selectedAddress =
            '${fullNameController.text.trim()}, '
            '${addressController.text.trim()}, '
            '${cityController.text.trim()}, '
            '${stateController.text.trim()}, '
            '${countryController.text.trim()}';
      }

      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }

      return selectedAddress;
    } catch (e) {
      if (mounted) {
        setState(() {
          isSaving = false;
        });

        Fluttertoast.showToast(
          msg: "Failed to save profile: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }

      return null;
    }
  }

  Future<void> handleSave() async {
    if (isSaving) return;

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String? selectedAddress = await saveProfile();

    if (!mounted) return;

    if (selectedAddress == null) {
      return;
    }

    // Show success dialog
    await showSuccessAnimation();

    if (!mounted) return;

    if (widget.fromCheckout) {
      Navigator.of(context).pop(selectedAddress);
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const bot()),
      (route) => false,
    );
  }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    );
  }
}
