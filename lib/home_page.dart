import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Adicione estes imports se suas páginas estiverem em arquivos separados.
// Ajuste os caminhos se necessário.
import 'guide_page.dart';
import 'faq_page.dart';

/// HomePage atualizada conforme pedidos:
/// - avatar.svg removido, usando somente assets/images/avatar.png (quadrado, sem recorte)
/// - '?' do Guia substituído por assets/svg/guia.svg, mesmo tamanho dos outros ícones e centralizado
/// - recycleCenter do botão central com w:37 h:36 (escalado) e centralizado na sua ellipse
/// - FAQ e Guia abrem suas respectivas páginas ao serem clicados
/// - aumenta um pouco o espaçamento entre Home <-> center e center <-> perfil

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Base artboard size (do CSS)
  static const double baseWidth = 430;
  static const double baseHeight = 932;

  String _greeting = 'Bom dia, ';
  String _backgroundImageAsset = 'assets/images/dia.png';
  String _userFirstName = 'Usuário'; // Valor padrão até carregar do banco
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initBrazilTime();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Recuperar o token do armazenamento seguro
      final String? token = await _storage.read(key: "token");
      
      if (token != null) {
        // Fazer requisição para obter dados do usuário
        final response = await http.get(
          Uri.parse("https://ria-green-backend-674627922547.southamerica-east1.run.app/perfil"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final String fullName = data['usuario']['nome'];
          
          // Extrair apenas o primeiro nome
          final String firstName = fullName.split(' ')[0];
          
          setState(() {
            _userFirstName = firstName;
            _updateGreetingText(); // Atualizar a saudação com o nome correto
          });
        } else {
          print("Erro ao carregar dados do usuário: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
    }
  }

  Future<void> _initBrazilTime() async {
    try {
      final String tz = await FlutterNativeTimezone.getLocalTimezone();
      // compute Brasília time (UTC-3) from UTC as fallback
      final nowUtc = DateTime.now().toUtc();
      final br = nowUtc.add(const Duration(hours: -3));
      _updateGreetingAndImage(br);

      // If device timezone seems to be Brazil, use local device time instead (more natural)
      if (tz.toLowerCase().contains('sao_paulo') ||
          tz.toLowerCase().contains('brasilia') ||
          tz.toLowerCase().contains('brazil')) {
        final deviceNow = DateTime.now();
        _updateGreetingAndImage(deviceNow);
      }
    } catch (_) {
      // fallback: compute from UTC
      final nowUtc = DateTime.now().toUtc();
      final br = nowUtc.add(const Duration(hours: -3));
      _updateGreetingAndImage(br);
    }
  }

  void _updateGreetingAndImage(DateTime br) {
    final hour = br.hour;
    String greetingPrefix;
    String image;

    if (hour >= 6 && hour <= 11) {
      greetingPrefix = 'Bom dia, ';
      image = 'assets/images/dia.png';
    } else if (hour >= 12 && hour <= 17) {
      greetingPrefix = 'Boa tarde, ';
      image = 'assets/images/tarde.png';
    } else {
      greetingPrefix = 'Boa noite, ';
      image = 'assets/images/noite.png';
    }

    setState(() {
      _greeting = greetingPrefix;
      _backgroundImageAsset = image;
    });
    
    _updateGreetingText(); // Atualizar o texto completo da saudação
  }

  void _updateGreetingText() {
    // Esta função é chamada sempre que _greeting ou _userFirstName mudar
    // Mas não atualizamos o estado aqui para evitar loops infinitos
    // Em vez disso, construímos o texto completo no build()
  }

  /// utility: scale values from design (430x932) to actual screen
  double s(double value, double scale) => value * scale;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // compute scale factor (use the smaller ratio to preserve layout proportions)
    final double scale = [
      size.width / baseWidth,
      size.height / baseHeight,
    ].reduce((a, b) => a < b ? a : b);

    // Construir o texto completo da saudação com o nome do usuário
    final String fullGreeting = _greeting + _userFirstName + '!';

    // sizes used for certain elements from the design
    final double logoWidth = s(86, scale);
    final double logoHeight = s(113, scale);
    final double pointsBlockWidth = s(184, scale);
    final double pointsBlockTop = s(376, scale); // conforme posicionamento do seu design

    // Rectangle 217 (design): width:405 height:75 left:12 top:89 (we center horizontally)
    final double topCardWidth = s(405, scale);
    final double topCardHeight = s(75, scale);
    final double topCardLeft = (size.width - topCardWidth) / 2;
    final double topCardTop = s(89, scale);

    // Avatar: square to avoid cropping (you asked square). Horizontal position preserved:
    // avatar absolute left = 30, rect left = 12 => relative left = 18
    final double avatarRelLeft = s(30 - 12, scale); // 18px scaled
    // vertical: center avatar inside rectangle as requested
    final double avatarSize = s(50, scale); // square (50px scaled)
    final double avatarRelTopCentered = (topCardHeight - avatarSize) / 2;

    // small green dot (Ellipse 33) original absolute left 63.33 top 141.74
    final double greenDotRelLeft = s(63.33 - 12, scale); // relative to rect
    final double greenDotRelTop = s(141.74 - 89, scale);
    final double greenDotSize = s(10.26, scale);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height < baseHeight * scale ? baseHeight * scale : size.height,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                // --- Image 6 (blurred background image) ---
                Positioned(
                  left: 0,
                  right: 0,
                  top: s(-12, scale),
                  height: s(388, scale),
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                    child: Image.asset(
                      _backgroundImageAsset,
                      fit: BoxFit.cover,
                      width: size.width,
                    ),
                  ),
                ),

                // --- Vector 1: usar o SVG vetorFundo.svg e fazê-lo expandir horizontalmente ---
                Positioned(
                  left: 0,
                  right: 0,
                  top: s(278, scale),
                  child: SizedBox(
                    height: s(654, scale),
                    child: SvgPicture.asset(
                      'assets/svg/vetorFundo.svg',
                      fit: BoxFit.fill,
                      width: size.width,
                    ),
                  ),
                ),

                // --- Top User Card: Rectangle 217 (CENTRALIZADO HORIZONTALMENTE) ---
                Positioned(
                  left: topCardLeft,
                  top: topCardTop,
                  width: topCardWidth,
                  height: topCardHeight,
                  child: Container(
                    // mantemos overflow para elementos posicionados parcialmente fora (se necessário)
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10 * scale),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6 * scale,
                          offset: Offset(0, 2 * scale),
                        )
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Row with avatar + texts. We use left padding = 18px (relative inside rect) to match your original position.
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.only(left: avatarRelLeft, right: s(14, scale)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // Avatar PNG (square to avoid cropping), vertically centered by Row
                                SizedBox(
                                  width: avatarSize,
                                  height: avatarSize,
                                  child: Image.asset(
                                    'assets/images/avatar.png',
                                    width: avatarSize,
                                    height: avatarSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                SizedBox(width: s(12, scale)),

                                // greeting and subtitle (kept as Column like previous working code)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // gradient text
                                      ShaderMask(
                                        shaderCallback: (bounds) {
                                          return const LinearGradient(
                                            colors: <Color>[Color(0xFF1279A9), Color(0xFF079221)],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                                        },
                                        blendMode: BlendMode.srcIn,
                                        child: Text(
                                          fullGreeting, // Usar a saudação completa com o nome
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22 * scale,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: s(4, scale)),
                                      Text(
                                        'Vamos reciclar!',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13 * scale,
                                          color: const Color(0xFF999999),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // small green online dot (Ellipse 33) with tiny white highlight (Group190)
                        Positioned(
                          left: greenDotRelLeft,
                          top: greenDotRelTop,
                          width: greenDotSize,
                          height: greenDotSize,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF28B446),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: s(5.56, scale),
                                height: s(4.44, scale),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Logo: sempre centralizada horizontalmente ---
                Positioned(
                  left: 0,
                  right: 0,
                  top: s(244, scale),
                  child: Center(
                    child: SizedBox(
                      width: logoWidth,
                      height: logoHeight,
                      child: SvgPicture.asset(
                        'assets/svg/logo3.svg',
                        width: logoWidth,
                        height: logoHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // --- Points block (Group 12586 / 0 Pontos Ria)
                Positioned(
                  left: (size.width - pointsBlockWidth) / 2,
                  top: pointsBlockTop,
                  width: pointsBlockWidth,
                  height: s(30, scale),
                  child: Center(
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svg/riapoints.svg',
                            width: s(29.78, scale),
                            height: s(28, scale),
                          ),
                          SizedBox(width: s(8, scale)),
                          Text(
                            '0 Pontos Ria',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 20 * scale,
                              color: const Color(0xFF079221),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // --- Grid of icon cards ---
                // Linha 1
                Positioned(
                  left: 0,
                  right: 0,
                  top: s(437, scale),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildIconCard(
                          title: 'Reciclar',
                          svg: 'assets/svg/recycle.svg',
                          scale: scale,
                          bgEllipse: const Color(0xFFE6F2EA),
                          onTap: () {
                            // caso queira ação ao clicar neste ícone
                          },
                        ),
                        SizedBox(width: s(12, scale)),
                        _buildIconCard(
                          title: 'Pontos de coleta',
                          svg: 'assets/svg/location.svg',
                          scale: scale,
                          bgEllipse: const Color(0xFFFFE9E5),
                        ),
                        SizedBox(width: s(12, scale)),
                        _buildIconCard(
                          title: 'Coleção',
                          svg: 'assets/svg/colecao.svg',
                          scale: scale,
                          bgEllipse: const Color(0xFFFFF6E3),
                        ),
                      ],
                    ),
                  ),
                ),

                // Linha 2
                Positioned(
                  left: 0,
                  right: 0,
                  top: s(571, scale),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildIconCard(
                          title: 'Dashboard',
                          svg: 'assets/svg/dashboard.svg',
                          scale: scale,
                          bgEllipse: const Color(0xFFF3EFFA),
                        ),
                        SizedBox(width: s(12, scale)),
                        _buildIconCard(
                          title: 'Artigos',
                          svg: 'assets/svg/artigos.svg',
                          scale: scale,
                          bgEllipse: const Color(0xFFDCF4F5),
                        ),
                        SizedBox(width: s(12, scale)),
                        _buildIconCard(
                          title: 'Seja Parceiro',
                          svg: 'assets/svg/sejaparceiro.svg',
                          scale: scale,
                          bgEllipse: const Color(0xFFFFE8F2),
                          svgSize: s(40, scale),
                        ),
                      ],
                    ),
                  ),
                ),

                // Linha 3 (com centro grande)
                Positioned(
                  left: 0,
                  right: 0,
                  top: s(705, scale),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // FAQ com navegação para FaqPage
                        _buildIconCard(
                          title: 'FAQ',
                          svg: 'assets/svg/faq.svg',
                          scale: scale,
                          bgEllipse: const Color(0xFFD2EFFF),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const FaqPage()),
                            );
                          },
                        ),
                        SizedBox(width: s(12, scale)),
                        // central big card (agora usando a mesma função _buildIconCard com o svg guia.svg)
                        // o svg do guia terá o mesmo tamanho que os outros ícones e ficará centralizado na ellipse
                        _buildIconCard(
                          title: 'Guia',
                          svg: 'assets/svg/guia.svg',
                          scale: scale,
                          bgEllipse: const Color(0x31B2DE27),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const GuidePage()),
                            );
                          },
                        ),
                        SizedBox(width: s(12, scale)),
                        _buildIconCard(
                          title: 'Outros',
                          svg: 'assets/svg/outros.svg',
                          scale: scale,
                          bgEllipse: const Color(0x31868689),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Bottom navigation bar area (Rectangle 13 / nav) ---
                Positioned(
                  left: 0,
                  right: 0,
                  top: s(842, scale),
                  height: s(90.26, scale),
                  child: Container(
                    color: Colors.transparent,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        // big white rect (fundo)
                        Positioned.fill(
                          child: Container(color: Colors.white),
                        ),

                        // compute center X and place icons relative to it
                        Builder(builder: (context) {
                          final double centerX = size.width / 2;
                          // aumentei um pouco o offset para separar Home <-> center e center <-> perfil
                          final double iconOffset = s(96, scale);

                          return Stack(
                            children: [
                              // left icon (home)
                              Positioned(
                                left: centerX - iconOffset - s(12, scale),
                                top: s(879.61 - 842, scale),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/svg/home.svg',
                                      width: s(30, scale),
                                      height: s(28, scale),
                                    ),
                                    SizedBox(height: s(8, scale)),
                                  ],
                                ),
                              ),

                              // center big green button - centralizado horizontalmente (tamanhos conforme CSS)
                              Positioned(
                                left: centerX - s(58.16, scale) / 2,
                                top: s(847.19 - 842, scale),
                                child: GestureDetector(
                                  onTap: () { /* ação do botão central */ },
                                  child: Container(
                                    width: s(58.16, scale),
                                    height: s(58.1, scale),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF079221),
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: const Color.fromRGBO(108, 197, 29, 0.26),
                                          blurRadius: 4 * scale,
                                          offset: Offset(0, 4 * scale),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: s(37, scale),
                                        height: s(36, scale),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF079221),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          // coloquei o SVG direto no centro da ellipse sem transform.scale
                                          child: SizedBox(
                                            width: s(37, scale),
                                            height: s(36, scale),
                                            child: SvgPicture.asset(
                                              'assets/svg/recycleCenter.svg',
                                              width: s(37, scale),
                                              height: s(36, scale),
                                              fit: BoxFit.contain,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // right icon (account)
                              Positioned(
                                left: centerX + iconOffset - s(12, scale),
                                top: s(879.61 - 842, scale),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/svg/perfil.svg',
                                      width: s(32, scale),
                                      height: s(34, scale),
                                    ),
                                    SizedBox(height: s(3 * scale, scale)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to build small icon card used many times.
  /// Optional [svgSize] allows increasing a single icon (used for "Seja Parceiro").
  /// Optional [onTap] handles click actions (ex: navegar para páginas).
  Widget _buildIconCard({
    required String title,
    required String svg,
    required double scale,
    required Color bgEllipse,
    double? svgSize,
    VoidCallback? onTap,
  }) {
    final double effectiveSvgSize = svgSize ?? s(34, scale);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: s(120, scale),
        height: s(120, scale),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBFB),
            borderRadius: BorderRadius.circular(5 * scale),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: s(16, scale)),
                  child: Container(
                    width: s(66, scale),
                    height: s(66, scale),
                    decoration: BoxDecoration(
                      color: bgEllipse,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        svg,
                        width: effectiveSvgSize,
                        height: effectiveSvgSize,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: s(12, scale)),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 10 * scale,
                      color: const Color(0xFF868889),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}