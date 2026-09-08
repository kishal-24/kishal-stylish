import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/forget.dart';
import 'package:untitled/sign.dart';
import 'package:untitled/str.dart';
import 'package:fluttertoast/fluttertoast.dart';

class actual extends StatefulWidget {
  const actual({super.key});

  @override
  State<actual> createState() => _actualState();
}

class _actualState extends State<actual> {
  bool hidepassword = true;
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String savedUsername = prefs.getString('username') ?? '';

    final String savedPassword = prefs.getString('password') ?? '';

    final String enteredUsername = usernameController.text.trim();

    final String enteredPassword = passwordController.text;

    if (enteredUsername == savedUsername && enteredPassword == savedPassword ) {
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => str()),
      );
    } else if (enteredUsername == savedUsername &&
        enteredPassword != savedPassword) {
      Fluttertoast.showToast(
        msg: "password is incorrect",
        toastLength: Toast.LENGTH_SHORT,
      );
    } else if (enteredUsername != savedUsername &&
        enteredPassword == savedPassword) {
      Fluttertoast.showToast(
        msg: "username or email is incorrect",
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Fluttertoast.showToast(
        msg: "user not found .please signup",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

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
                padding: const EdgeInsets.only(top: 100, left: 50, right: 200),

                child: const Text(
                  "welcome back",

                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.w800),
                ),
              ),

              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 460,

                      child: TextFormField(
                        controller: usernameController,

                        decoration: InputDecoration(
                          hintText: "Username or email",

                          hintStyle: const TextStyle(fontSize: 22),

                          prefixIcon: const Icon(Icons.person),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 30,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
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
                        controller: passwordController,

                        obscureText: hidepassword,

                        decoration: InputDecoration(
                          hintText: "Password",

                          hintStyle: const TextStyle(fontSize: 22),

                          prefixIcon: const Icon(Icons.lock),

                          suffixIcon: IconButton(
                            icon: Icon(
                              hidepassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),

                            onPressed: () {
                              setState(() {
                                hidepassword = !hidepassword;
                              });
                            },
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 30,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        validator: (value) {
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
                    SizedBox(
                      height: 50,

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => const forget(),
                            ),
                          );
                        },

                        child: const Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 300,
                            top: 10,
                          ),

                          child: Text(
                            "forget password",

                            style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.pink,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: login,

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 200,
                          vertical: 25,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.pink,

                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: const Text(
                          "Login",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),

                      child: Text(
                        "-or continue with-",

                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                        left: 150,
                        right: 150,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Image.asset('assets/Google.png'),

                          Image.asset('assets/apple.png'),

                          Image.asset('assets/Facebook.png'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Text(
                            'create an account',

                            style: TextStyle(fontSize: 19),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (context) => const sign(),
                                ),
                              );
                            },

                            child: const Text(
                              ' signup',

                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.pink,

                                decoration: TextDecoration.underline,

                                decorationColor: Colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
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
