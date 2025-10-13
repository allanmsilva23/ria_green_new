import 'dart:async';
import 'package:flutter/material.dart';
import 'logo_widget.dart'; // Importe o widget do logo
import 'inicial_page.dart';

class Splash2Screen extends StatefulWidget {
  const Splash2Screen({super.key});

  @override
  State<Splash2Screen> createState() => _SplashScreenState();}

class _SplashScreenState extends State<Splash2Screen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const InicialPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 100),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Logo centralizado
            Center(
              child: const LogoWidget(), // Aqui usamos o novo widget
            ),

            // ... (mantenha os outros elementos vetoriais)
          ],
        ),
      ),
    );
  }
}