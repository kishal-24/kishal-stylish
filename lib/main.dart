
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylish/bloc/auth/auth_bloc.dart';
import 'package:stylish/bloc/cart/cart_bloc.dart';
import 'package:stylish/bloc/cart/cart_event.dart';
import 'package:stylish/bloc/favorite/favorite_bloc.dart';
import 'package:stylish/bloc/product/product_bloc.dart';
import 'package:stylish/bloc/product/product_event.dart';
import 'package:stylish/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylish/screens/firebase_options.dart';
import 'package:stylish/screens/login.dart';
import 'package:stylish/widget/bot.dart';
import 'package:stylish/widget/loading_skeleton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: AuthRepository())),
        BlocProvider(create: (_) => CartBloc()..add(const LoadCart())),
        BlocProvider(create: (_) => FavoriteBloc()),
        BlocProvider(create: (_) => ProductBloc()..add(const FetchProducts())),
      ],
      child: MaterialApp(
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSkeleton();
        }

        if (snapshot.hasData) {
          return const bot();
        }

        return const login();
      },
    );
  }
}

