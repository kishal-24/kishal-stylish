import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/screens/actual.dart';
import 'package:fluttertoast/fluttertoast.dart';

class sign extends StatefulWidget {
  const sign({super.key});

  @override
  State<sign> createState() => _signState();
}

class _signState extends State<sign> {
  bool hidepassword = true;
  bool hideConfirmPassword = true;
  final TextEditingController usernameController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  Future<void> createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (passwordController.text !=
        confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: "Password and confirm password do not match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );

      return;
    }
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      'username',
      usernameController.text.trim(),
    );
    await prefs.setString(
      'password',
      passwordController.text,
    );
    Fluttertoast.showToast(
      msg: "Account created successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const actual(),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 50,
                  right: 200,
                ),

                child: const Text(
                  "create an account",

                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Center(
                child: Column(
                  children: [

                    const SizedBox(height: 50),
                    SizedBox(
                      width: 460,

                      child: TextFormField(
                        controller:
                        usernameController,

                        decoration:
                        InputDecoration(
                          hintText:
                          "Username or email",

                          hintStyle:
                          const TextStyle(
                            fontSize: 22,
                          ),

                          prefixIcon:
                          const Icon(
                            Icons.person,
                          ),

                          contentPadding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 20,
                            vertical: 30,
                          ),

                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius
                                .circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter username or email';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 30),


                    SizedBox(
                      width: 460,

                      child: TextFormField(
                        controller:
                        passwordController,

                        obscureText:
                        hidepassword,

                        decoration:
                        InputDecoration(
                          hintText:
                          "Password",

                          hintStyle:
                          const TextStyle(
                            fontSize: 22,
                          ),

                          prefixIcon:
                          const Icon(
                            Icons.lock,
                          ),

                          suffixIcon:
                          IconButton(
                            icon: Icon(
                              hidepassword
                                  ? Icons
                                  .visibility_off
                                  : Icons.visibility,
                            ),

                            onPressed: () {
                              setState(() {
                                hidepassword =
                                !hidepassword;
                              });
                            },
                          ),

                          contentPadding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 30,
                            vertical: 30,
                          ),

                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius
                                .circular(10),
                          ),
                        ),validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: 460,

                      child: TextFormField(
                        controller:
                        confirmPasswordController,

                        obscureText:
                        hideConfirmPassword,

                        decoration:
                        InputDecoration(
                          hintText:
                          "Confirm Password",

                          hintStyle:
                          const TextStyle(
                            fontSize: 22,
                          ),

                          prefixIcon:
                          const Icon(
                            Icons.lock,
                          ),

                          suffixIcon:
                          IconButton(
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons
                                  .visibility_off
                                  : Icons.visibility,
                            ),

                            onPressed: () {
                              setState(() {
                                hideConfirmPassword =
                                !hideConfirmPassword;
                              });
                            },
                          ),

                          contentPadding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 30,
                            vertical: 30,
                          ),

                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius
                                .circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Please confirm password';
                          }

                          return null;
                        },
                      ),
                    ),

                    SizedBox(
                      child: const Padding(
                        padding:
                        EdgeInsetsDirectional
                            .only(
                          end: 150,
                          top: 15,
                          start: 45,
                        ),

                        child: Text.rich(
                          TextSpan(
                            children: [

                              TextSpan(
                                text: "by clicking ",
                                style: TextStyle(
                                  fontSize: 21,
                                  color:
                                  Colors.grey,
                                ),
                              ),

                              TextSpan(
                                text: "register",
                                style: TextStyle(
                                  fontSize: 21,
                                  color:
                                  Colors.pink,
                                  decoration:
                                  TextDecoration
                                      .underline,
                                  decorationColor:
                                  Colors.grey,
                                ),
                              ),

                              TextSpan(
                                text:
                                " button, you agree to public offer",
                                style: TextStyle(
                                  fontSize: 21,
                                  color:
                                  Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: createAccount,

                      child: Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 140,
                          vertical: 25,
                        ),

                        decoration:
                        BoxDecoration(
                          color: Colors.pink,

                          borderRadius:
                          BorderRadius
                              .circular(10),
                        ),

                        child: const Text(
                          "create account",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                      EdgeInsets.only(top: 20),

                      child: Text(
                        "-or continue with-",

                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(
                        top: 25,
                        left: 150,
                        right: 150,
                      ),

                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceEvenly,

                        children: [

                          Image.asset(
                            'assets/Google.png',
                          ),

                          Image.asset(
                            'assets/apple.png',
                          ),

                          Image.asset(
                            'assets/Facebook.png',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(
                        top: 20,
                      ),

                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                        children: [

                          const Text(
                            'I already have an account',

                            style: TextStyle(
                              fontSize: 19,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                  const actual(),
                                ),
                              );
                            },

                            child: const Text(
                              ' login',

                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.pink,

                                decoration:
                                TextDecoration
                                    .underline,

                                decorationColor:
                                Colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}