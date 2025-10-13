import 'package:flutter/material.dart';
import 'intro2_page.dart';
import 'intro4_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late Image backgroundImage;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    backgroundImage = Image.asset(
      'assets/images/Reciclagem-Eletronica.jpg',
      fit: BoxFit.cover,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(backgroundImage.image, context);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;

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
    double baseWidth = deviceType == DeviceType.tablet
        ? 768
        : deviceType == DeviceType.desktop
            ? 1024
            : 375;

    final scale = screenWidth / baseWidth;
    final textScale = scale.clamp(0.8, 1.6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Fundo ondulado com imagem
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
                    : screenHeight * 0.55,
                child: Text(
                  'Transforme Resíduos em Recursos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: deviceType == DeviceType.mobile
                        ? 24 * textScale.clamp(0.9, 1.2)
                        : 32 * textScale.clamp(0.9, 1.4),
                    height: 1.2,
                    color: const Color(0xFF2993A1),
                  ),
                ),
              ),

              // Texto descritivo
              Positioned(
                left: 0.0674 * screenWidth,
                right: 0.0674 * screenWidth,
                top: deviceType == DeviceType.mobile
                    ? screenHeight * 0.64
                    : screenHeight * 0.63,
                child: Text(
                  'Com a RIA Green, você dá um destino correto ao lixo eletrônico e ajuda a construir um futuro mais sustentável.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16 * textScale,
                    height: 1.6,
                    color: const Color(0xFF2993A1),
                  ),
                ),
              ),

              // Indicadores
              Positioned(
                bottom: deviceType == DeviceType.mobile
                    ? height * 0.21
                    : height * 0.25,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(true, scale),
                    SizedBox(width: 16.81 * scale),
                    _buildDot(false, scale),
                    SizedBox(width: 16.81 * scale),
                    _buildDot(false, scale),
                    SizedBox(width: 16.81 * scale),
                    _buildDot(false, scale),
                  ],
                ),
              ),

              // Botão "Próximo"
              Positioned(
                bottom: screenHeight * 0.12,
                left: screenWidth * 0.30,
                right: screenWidth * 0.30,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (_, animation, __) => const Intro2Page(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.1, 0.0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8 * scale),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2993A1),
                      borderRadius: BorderRadius.circular(11 * scale),
                    ),
                    child: Center(
                      child: Text(
                        'Próximo',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: deviceType == DeviceType.mobile
                              ? 20 * textScale
                              : 25 * textScale,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Botão "Pular"
              Positioned(
                bottom: height * 0.063,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Intro4Page()),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Pular',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 18 * textScale,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF2993A1),
                        color: const Color(0xFF2993A1),
                      ),
                    ),
                  ),
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
      width: 10.79 * scale.clamp(0.7, 1.5),
      height: 10.79 * scale.clamp(0.7, 1.5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2993A1) : const Color(0xFFD9D9D9),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF2993A1).withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ]
            : [],
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
