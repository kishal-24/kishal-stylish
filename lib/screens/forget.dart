import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_services.dart';

class forget extends StatefulWidget {
  const forget({super.key});

  @override
  State<forget> createState() => _ForgetState();
}

class _ForgetState extends State<forget> {
  final TextEditingController emailController =
  TextEditingController();

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final AuthService authService = AuthService();

  bool isLoading = false;

  Future<void> sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String email =
    emailController.text.trim();

    setState(() {
      isLoading = true;
    });

    try {
      await authService.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: 'Password reset link sent to your email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email';
          break;

        case 'network-request-failed':
          message = 'Please check your internet connection';
          break;

        default:
          message =
              e.message ?? 'Failed to send reset link';
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 80,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                const Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Enter your email and we will send you a password reset link.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                TextFormField(
                  controller: emailController,

                  keyboardType:
                  TextInputType.emailAddress,

                  decoration: InputDecoration(
                    hintText: 'Email',

                    prefixIcon: const Icon(
                      Icons.email,
                    ),

                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 25,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed:
                    isLoading ? null : sendResetLink,

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFFF83758),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                      width: 25,
                      height: 25,

                      child:
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}