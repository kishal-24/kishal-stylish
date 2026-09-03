import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const homePage(),

    );

  }
}
// class StartPage extends StatefulWidget {
//   const StartPage({super.key});
//
//   @override
//   State<StartPage> createState() => _StartPageState();
//  }
// //
// class _StartPageState extends State<StartPage> {
//
//   @override
//   void initState() {
//     super.initState();
//     checkLogin();
//   }
//
//   Future<void> checkLogin() async {
//
//     final SharedPreferences prefs =
//     await SharedPreferences.getInstance();
//
//     final bool isLoggedIn =
//         prefs.getBool('isLoggedIn') ?? false;
//
//     if (!mounted) return;
//
//     if (isLoggedIn) {
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const home(),
//         ),
//       );
//
//     } else {
//
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const actual(),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
