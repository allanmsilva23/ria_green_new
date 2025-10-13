import 'package:flutter/material.dart';
import 'intro_page.dart';
import 'intro3_page.dart';

class Intro2Page extends StatefulWidget {
  const Intro2Page({super.key});

  @override
  State<Intro2Page> createState() => _Intro2PageState();
}

class _Intro2PageState extends State<Intro2Page>
    with SingleTickerProviderStateMixin {
  late Image backgroundImage;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Pré-carrega a imagem
    backgroundImage = Image.asset(
      'assets/images/Reciclagem-Especializada.jpg',
      fit: BoxFit.cover,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(backgroundImage.image, context);
    });

    // Controla a animação de deslocamento horizontal
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;

    // Move apenas a sobra da largura
    _animation = Tween<double>(
      begin: 0,
      end: -(width * 0.2),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    final double buttonWidth = deviceType == DeviceType.mobile ? 120 : 90;
    final double buttonHeight = deviceType == DeviceType.mobile ? 48 : 36;
    final double fontSize = deviceType == DeviceType.mobile ? 18 : 16;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Fundo ondulado branco
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipPath(
                      clipper: WaveClipper(),
                      child: SizedBox(
                        width: width * 1.2,
                        height: screenHeight * 0.55,
                        child: backgroundImage,
                      ),
                    );
                  },
                ),
              ),

              // Título
              Positioned(
                left: 0.0372 * screenWidth,
                right: 0.0372 * screenWidth,
                top: deviceType == DeviceType.mobile
                    ? screenHeight * 0.55
                    : screenHeight * 0.57,
                child: Text(
                  'Reciclagem Especializada e Segura',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: deviceType == DeviceType.mobile
                        ? 24 * textScale.clamp(0.9, 1.2)
                        : 32 * textScale.clamp(0.9, 1.4),
                    height: 1.2,
                    color: const Color(0xFF00336D),
                  ),
                ),
              ),

              // Texto descritivo
              Positioned(
                left: 0.0674 * screenWidth,
                right: 0.0674 * screenWidth,
                top: deviceType == DeviceType.mobile
                    ? screenHeight * 0.64
                    : screenHeight * 0.645,
                child: Text(
                  'Descarte seus eletrônicos com responsabilidade e colabore com processos que purificam e reaproveitam materiais valiosos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 16 * textScale,
                    height: 1.6,
                    color: const Color(0xFF00336D),
                  ),
                ),
              ),

              // Indicadores de página
              Positioned(
                bottom: deviceType == DeviceType.mobile
                    ? height * 0.19
                    : height * 0.20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(false, scale),
                    SizedBox(width: 16.81 * scale),
                    _buildDot(true, scale),
                    SizedBox(width: 16.81 * scale),
                    _buildDot(false, scale),
                    SizedBox(width: 16.81 * scale),
                    _buildDot(false, scale),
                  ],
                ),
              ),

              // Botões: Voltar e Avançar
              Positioned(
                bottom: deviceType == DeviceType.mobile
                    ? height * 0.10
                    : height * 0.07,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Voltar (anima da esquerda para direita)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder: (_, animation, __) =>
                                const IntroPage(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-0.1, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: buttonWidth * scale,
                        height: buttonHeight * scale,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFA1A4B2)),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Voltar',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize * scale.clamp(0.8, 1.2),
                            color: const Color(0xFFA1A4B2),
                          ),
                        ),
                      ),
                    ),

                    // Avançar (anima da direita para esquerda)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder: (_, animation, __) =>
                                const Intro3Page(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.1, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: buttonWidth * scale,
                        height: buttonHeight * scale,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00336D),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Avançar',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize * scale.clamp(0.8, 1.2),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDot(bool isActive, double scale) {
    return Container(
      width: 10.79 * scale.clamp(0.7, 1.2),
      height: 10.79 * scale.clamp(0.7, 1.2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF00336D) : const Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
    );
  }

  DeviceType _getDeviceType(double width) {
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

enum DeviceType { mobile, tablet, desktop }

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
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}