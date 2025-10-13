import 'package:flutter/material.dart';
import 'splash2_screen.dart';

class Intro4Page extends StatefulWidget {
  const Intro4Page({super.key});

  @override
  State<Intro4Page> createState() => _Intro4PageState();
}

class _Intro4PageState extends State<Intro4Page>
    with SingleTickerProviderStateMixin {
  late Image backgroundImage;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Carregar imagem antecipadamente
    backgroundImage = Image.asset(
      'assets/images/Movimento-Verde.jpg',
      fit: BoxFit.cover,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(backgroundImage.image, context);
    });

    // Animação horizontal da imagem
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
      end: -(width * 0.2), // movimento horizontal suave
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
                  'Junte-se ao Movimento Verde',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: deviceType == DeviceType.mobile
                        ? 24 * textScale.clamp(0.9, 1.2)
                        : 32 * textScale.clamp(0.9, 1.4),
                    height: 1.2,
                    color: const Color(0xFF079121),
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
                  'Seja um agente da transformação com a Ria Green. Recicle, inove e colabore para um planeta mais limpo e sustentável.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 16 * textScale,
                    height: 1.6,
                    color: const Color(0xFF079121),
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
                    _buildDot(false, scale),
                    SizedBox(width: 16.81 * scale),
                    _buildDot(false, scale),
                    SizedBox(width: 16.81 * scale),
                    _buildDot(true, scale),
                  ],
                ),
              ),

              // Botão "Vamos começar" com mesma transição do botão "Próximo"
              Positioned(
                bottom: deviceType == DeviceType.mobile
                    ? height * 0.10
                    : height * 0.07,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (_, animation, __) =>
                              const Splash2Screen(),
                          transitionsBuilder: (_, animation, __, child) {
                            // Apenas fade na transição final
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  child: Container(
                    width: deviceType == DeviceType.mobile
                        ? 200 * scale.clamp(1, 1.3) // menor para mobile
                        : 289 * scale.clamp(0.8, 1.3), // padrão para tablet e desktop
                    padding: EdgeInsets.symmetric(
                      vertical: deviceType == DeviceType.mobile ? 8 * scale : 8 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF079121),
                      borderRadius: BorderRadius.circular(11 * scale),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Vamos começar',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: deviceType == DeviceType.mobile
                            ? 20 * scale.clamp(0.8, 1.2) // fonte menor para mobile
                            : 25 * scale.clamp(0.8, 1.2),
                        letterSpacing: 0.05,
                        color: Colors.white,
                                    ),
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

  /// Indicador (bolinha)
  Widget _buildDot(bool isActive, double scale) {
    return Container(
      width: 10.79 * scale.clamp(0.7, 1.2),
      height: 10.79 * scale.clamp(0.7, 1.2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF079121) : const Color(0xFFD9D9D9),
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