import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stylish/bloc/auth/auth_bloc.dart';
import 'package:stylish/bloc/auth/auth_event.dart';
import 'package:stylish/bloc/auth/auth_state.dart';
import 'package:stylish/screens/forget.dart';
import 'package:stylish/screens/sign.dart';
import 'package:stylish/screens/str.dart';

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
  void login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(
        email: usernameController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Fluttertoast.showToast(
            msg: 'Login successful',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => str()),
          );
        } else if (state is AuthFailure) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
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
                      "welcome back",
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.w800,
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
                            controller: usernameController,

                            keyboardType: TextInputType.emailAddress,

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
                                return 'Please enter email';
                              }

                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
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
                          onTap: isLoading ? null : login,

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 200,
                              vertical: 25,
                            ),

                            decoration: BoxDecoration(
                              color: isLoading ? Colors.grey : Colors.pink,

                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: isLoading
                                ? const SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
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
                              GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () => context.read<AuthBloc>().add(
                                        const GoogleLoginRequested(),
                                      ),
                                child: Image.asset(
                                  'assets/Google.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ),

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
      },
    );
  }
}
