import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mybudgetdiary/common/sharedpreference.dart';
import 'package:mybudgetdiary/features/authentication/login_screen.dart';
import 'package:mybudgetdiary/features/homepage/homepage_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreference.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: UserPreference.isLoggedIn() ? const HomePage() : const Login(),
    );
  }
}
