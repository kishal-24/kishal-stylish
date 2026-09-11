
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:untitled/screens/actual.dart';

import '../services/auth_services.dart';

class sign extends StatefulWidget {
const sign({super.key});

@override
State<sign> createState() => _signState();
}

class _signState extends State<sign> {
bool hidepassword = true;
bool hideConfirmPassword = true;
bool isLoading = false;

final TextEditingController usernameController =
TextEditingController();

final TextEditingController mobileController =
TextEditingController();

final TextEditingController passwordController =
TextEditingController();

final TextEditingController confirmPasswordController =
TextEditingController();

final GlobalKey<FormState> _formKey =
GlobalKey<FormState>();

final AuthService _authService = AuthService();


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

  setState(() {
    isLoading = true;
  });

  try {
    // Create Firebase account
    await _authService.createAccount(
      email: usernameController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Account created successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    // Go to Login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const actual(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    String message = "Something went wrong";

    switch (e.code) {
      case 'email-already-in-use':
        message = "Email is already registered";
        break;

      case 'invalid-email':
        message = "Invalid email address";
        break;

      case 'weak-password':
        message = "Password must be at least 6 characters";
        break;

      case 'operation-not-allowed':
        message =
        "Email/password authentication is not enabled";
        break;

      case 'network-request-failed':
        message = "Check your internet connection";
        break;

      default:
        message =
            e.message ?? "Account creation failed";
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Something went wrong",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}


@override
void dispose() {
usernameController.dispose();
mobileController.dispose();
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
controller: usernameController,
keyboardType:
TextInputType.emailAddress,
decoration: InputDecoration(
hintText: "Email",
hintStyle: const TextStyle(
fontSize: 22,
),
prefixIcon: const Icon(
Icons.email_outlined,
),
contentPadding:
const EdgeInsets.symmetric(
horizontal: 20,
vertical: 30,
),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(10),
),
),
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return 'Please enter email';
}

if (!RegExp(
r'^[^@]+@[^@]+\.[^@]+',
).hasMatch(value.trim())) {
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
hintStyle: const TextStyle(
fontSize: 22,
),
prefixIcon: const Icon(
Icons.lock,
),
suffixIcon: IconButton(
icon: Icon(
hidepassword
? Icons.visibility_off
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
const EdgeInsets.symmetric(
horizontal: 30,
vertical: 30,
),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(10),
),
),
validator: (value) {
if (value == null ||
value.isEmpty) {
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
decoration: InputDecoration(
hintText: "Confirm Password",
hintStyle: const TextStyle(
fontSize: 22,
),
prefixIcon: const Icon(
Icons.lock,
),
suffixIcon: IconButton(
icon: Icon(
hideConfirmPassword
? Icons.visibility_off
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
const EdgeInsets.symmetric(
horizontal: 30,
vertical: 30,
),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(10),
),
),
validator: (value) {
if (value == null ||
value.isEmpty) {
return 'Please confirm password';
}

if (value !=
passwordController.text) {
return 'Passwords do not match';
}

return null;
},
),
),



SizedBox(
child: const Padding(
padding:
EdgeInsetsDirectional.only(
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
color: Colors.grey,
),
),
TextSpan(
text: "register",
style: TextStyle(
fontSize: 21,
color: Colors.pink,
decoration:
TextDecoration.underline,
decorationColor:
Colors.grey,
),
),
TextSpan(
text:
" button, you agree to public offer",
style: TextStyle(
fontSize: 21,
color: Colors.grey,
),
),
],
),
),
),
),

const SizedBox(height: 30),
GestureDetector(
onTap:
isLoading ? null : createAccount,
child: Container(
padding:
const EdgeInsets.symmetric(
horizontal: 140,
vertical: 25,
),
decoration: BoxDecoration(
color: isLoading
? Colors.grey
    : Colors.pink,
borderRadius:
BorderRadius.circular(10),
),
child: isLoading
? const SizedBox(
width: 35,
height: 35,
child:
CircularProgressIndicator(
color: Colors.white,
strokeWidth: 3,
),
)
    : const Text(
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
MainAxisAlignment.spaceEvenly,
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
const EdgeInsets.only(top: 20),
child: Row(
mainAxisAlignment:
MainAxisAlignment.center,
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
builder: (context) =>
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
TextDecoration.underline,
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

