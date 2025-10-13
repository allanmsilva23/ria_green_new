import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'terms_service.dart';
import 'privacy_policy.dart';
import 'signup_page.dart';     // importe a SignUpPage
import 'home_page.dart';      // importe a HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // tela inicial do app
      home: const SplashScreen(),
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/terms_service': (context) => const TermsServicePage(),
        '/privacy_policy': (context) => const PrivacyPolicyPage(),
      },
    );
  }
}
