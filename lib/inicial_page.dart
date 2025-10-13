import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'signin_page.dart';
import 'signup_page.dart';

class InicialPage extends StatelessWidget {
  const InicialPage({super.key});

  DeviceType _getDeviceType(double width) {
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceType = _getDeviceType(screenWidth);

    double baseWidth = 375;
    if (deviceType == DeviceType.tablet) baseWidth = 768;
    if (deviceType == DeviceType.desktop) baseWidth = 1024;

    final scale = screenWidth / baseWidth;
    final textScale = scale.clamp(0.8, 1.6);

    double logoWidth;
    double logoHeight;
    switch (deviceType) {
      case DeviceType.mobile:
        logoWidth = 250;
        logoHeight = 150;
        break;
      case DeviceType.tablet:
        logoWidth = 300;
        logoHeight = 180;
        break;
      case DeviceType.desktop:
        logoWidth = 450;
        logoHeight = 270;
        break;
    }

    double buttonWidth;
    EdgeInsetsGeometry buttonMargin;
    switch (deviceType) {
      case DeviceType.mobile:
        buttonWidth = 270 * scale.clamp(0.7, 1.4);
        buttonMargin = EdgeInsets.symmetric(vertical: 10 * scale);
        break;
      case DeviceType.tablet:
        buttonWidth = 360 * scale.clamp(0.7, 1.4);
        buttonMargin = EdgeInsets.symmetric(vertical: 25 * scale);
        break;
      case DeviceType.desktop:
        buttonWidth = 850;
        buttonMargin = const EdgeInsets.only(top: 20, bottom: 1);
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Topo com fundo ondulado e imagem
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        width: constraints.maxWidth,
                        height: screenHeight * 0.55,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Movimento-Verde-Blur.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/svg/logo2.svg",
                      width: logoWidth,
                      height: logoHeight,
                    ),
                  ],
                ),

                // Título
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * scale,
                    vertical: 16 * scale,
                  ),
                  child: Text(
                    "Junte-se a Ria Green",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      fontSize: 30 * textScale,
                      color: const Color(0xFF079121),
                    ),
                  ),
                ),

                // Subtítulo
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * scale,
                    vertical: 8 * scale,
                  ),
                  child: Text(
                    "Entre ou cadastre-se e ajude a construir um futuro mais sustentável",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 16 * textScale,
                      height: 1.6,
                      color: const Color.fromARGB(128, 0, 63, 12),
                    ),
                  ),
                ),

                SizedBox(height: 1 * scale),

                // Botão Entrar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInPage()),
                    );
                  },
                  child: Container(
                    width: buttonWidth,
                    margin: buttonMargin,
                    height: deviceType == DeviceType.mobile
                    ? 50 * scale           // altura menor apenas para mobile
                    : 63 * scale.clamp(0.7, 1.4),  // altura padrão para tablet e desktop
                    decoration: BoxDecoration(
                      color: const Color(0xFF079121),
                      borderRadius: BorderRadius.circular(38),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 22 * textScale,
                        color: const Color(0xFFF6F1FB),
                        letterSpacing: 0.05,
                      ),
                    ),
                  ),
                ),

                // Botão Cadastrar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Container(
                    width: buttonWidth,
                    margin: buttonMargin,
                    height: deviceType == DeviceType.mobile
                    ? 50 * scale           // altura menor apenas para mobile
                    : 63 * scale.clamp(0.7, 1.4),  // altura padrão para tablet e desktop
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF079121), width: 3),
                      borderRadius: BorderRadius.circular(38),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 22 * textScale,
                        color: const Color(0xFF079121),
                        letterSpacing: 0.05,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15 * scale),

                // Termos e políticas
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 * scale),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 10 * textScale,
                        color: const Color(0xFF079121),
                        letterSpacing: 0.05,
                      ),
                      children: [
                        const TextSpan(text: "Ao efetuar login ou registrar-se, você concorda com nossos "),
                        TextSpan(
                          text: "Termos de Serviço",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/terms_service');
                            },
                        ),
                        const TextSpan(text: " e "),
                        TextSpan(
                          text: "Política de Privacidade",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/privacy_policy');
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 25 * scale),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(
      firstControlPoint.dx, firstControlPoint.dy,
      firstEndPoint.dx, firstEndPoint.dy,
    );

    path.quadraticBezierTo(
      secondControlPoint.dx, secondControlPoint.dy,
      secondEndPoint.dx, secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

enum DeviceType { mobile, tablet, desktop }