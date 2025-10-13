import 'dart:async';
import 'package:flutter/material.dart';
import 'logo_widget.dart'; // Importe o widget do logo
import 'intro_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Pré-carregar imagens após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/Reciclagem-Eletronica.jpg'), context);
      precacheImage(const AssetImage('assets/images/Reciclagem-Especializada.jpg'), context);
      precacheImage(const AssetImage('assets/images/Pontos-Inteligentes.jpg'), context);
      precacheImage(const AssetImage('assets/images/Movimento-Verde.jpg'), context);
    });

    // Timer para trocar de página
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const IntroPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
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
            const Center(
              child: LogoWidget(),
            ),

            // ... (mantenha os outros elementos vetoriais)
          ],
        ),
      ),
    );
  }
}