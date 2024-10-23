import 'package:flutter/material.dart';
import 'package:labs/ui/home_page.dart';
import 'package:labs/ui/login_page.dart';
import 'package:labs/ui/profile_page.dart';
import 'package:labs/ui/registration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/profile': (context) => const ProfilePage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
