// lib/faq_page.dart
import 'dart:math';
import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  // Conteúdo de exemplo — substitua quando quiser
  static final List<Map<String, String>> _faqItems = [
    {
      'q': 'Como funciona o aplicativo?',
      'a': 'O aplicativo permite registrar pontos de coleta, acompanhar pontuação e agendar coletas. Explore o menu principal para acessar cada funcionalidade.'
    },
    {
      'q': 'Como cadastrar um ponto de coleta?',
      'a': 'Vá em "Pontos de coleta", clique em "Adicionar" e preencha os dados do local. Depois confirme para aparecer no mapa.'
    },
    {
      'q': 'O app funciona offline?',
      'a': 'Algumas funcionalidades básicas funcionam offline, mas recursos como mapas e sincronização exigem conexão à internet.'
    },
    {
      'q': 'Como ganho pontos?',
      'a': 'Você ganha pontos ao registrar entregas em pontos de coleta parceiros e ao cumprir missões dentro do app.'
    },
    {
      'q': 'Como resgatar pontos?',
      'a': 'No menu Exchange você pode ver as opções disponíveis e trocar seus pontos por recompensas.'
    },
    {
      'q': 'Onde encontro suporte?',
      'a': 'Acesse o menu de ajuda ou entre em contato pelo e-mail suporte@exemplo.com.'
    },
  ];

  // Base artboard from your CSS/design
  static const double _baseWidth = 430.0;
  static const double _baseHeight = 932.0;

  double _s(double value, double scale) => value * scale;

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    // scale factor — usamos o menor para preservar proporções como no design
    final double scale = [
      screen.width / _baseWidth,
      screen.height / _baseHeight,
    ].reduce(min);

    // design measurements (converted)
    final Color bgColor = const Color(0xFFF4F5F9); // #F4F5F9
    final Color titleColor = const Color(0xFF00336D); // #00336D
    final Color dividerColor = const Color(0xFFD7DEF0); // #D7DEF0
    final Color bodyTextColor = const Color.fromRGBO(60, 60, 67, 0.85);

    final double topBarHeight = _s(120, scale); // Rectangle 1443 height
    final double titleFontSize = _s(32, scale); // FAQ display
    final double imageLeft = _s(44, scale); // image left from CSS
    final double imageTopFromArtboard = _s(142, scale);
    final double questionsLeft = _s(27, scale);
    final double questionsTopFromArtboard = _s(415, scale);
    final double contentMaxWidth = min(screen.width - _s(34, scale), _s(397, scale)); // comfortable max width
    final double imageDesignWidth = _s(343, scale);
    final double imageDesignHeight = _s(257.26, scale);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Container(
              height: topBarHeight,
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: _s(16, scale)),
              child: Stack(
                children: [
                  // back arrow left
                  Positioned(
                    left: _s(21, scale),
                    top: _s(40, scale),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: SizedBox(
                        width: _s(40, scale),
                        height: _s(40, scale),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            size: _s(22, scale),
                            color: titleColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // centered title "FAQ"
                  Positioned(
                    top: _s(40, scale),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'FAQ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: titleFontSize,
                          height: 1.0,
                          letterSpacing: 0.12,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content area (scrollable)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: LayoutBuilder(builder: (context, constraints) {
                  // center content horizontally on wide screens
                  final double horizontalGutter = max((constraints.maxWidth - contentMaxWidth) / 2, _s(12, scale));
                  final double imageLeftPadding = horizontalGutter + imageLeft;

                  // compute dynamic top spacing between topbar and image to mimic top:142
                  // but ensure a minimum spacing so it adapts to short screens
                  final double topSpacing = max(imageTopFromArtboard - topBarHeight, _s(12, scale));

                  return Padding(
                    padding: EdgeInsets.only(
                      left: horizontalGutter,
                      right: horizontalGutter,
                      top: topSpacing,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IMAGE block positioned like CSS left:44 top:142 (we use padding + alignment)
                        Padding(
                          padding: EdgeInsets.only(left: imageLeft),
                          child: Container(
                            width: min(imageDesignWidth, contentMaxWidth - imageLeft),
                            height: imageDesignHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_s(8, scale)),
                              image: const DecorationImage(
                                image: AssetImage('images/faq_image.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: _s(24, scale)),

                        // Questions block (left:27 top:415 in artboard) -> we keep inner padding to match left:27
                        Padding(
                          padding: EdgeInsets.only(left: questionsLeft, right: questionsLeft),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: contentMaxWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title (Perguntas Frequentes)
                                Padding(
                                  padding: EdgeInsets.only(bottom: _s(24, scale)),
                                  child: Text(
                                    'Perguntas Frequentes',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: _s(24, scale),
                                      height: 1.2,
                                      color: titleColor,
                                    ),
                                  ),
                                ),

                                // Accordion surface (white background with blocks inside)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(_s(8, scale)),
                                  ),
                                  child: Column(
                                    children: [
                                      // each FAQ item as ExpansionTile with divider below
                                      for (int i = 0; i < _faqItems.length; i++) ...[
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                          ),
                                          child: ExpansionTile(
                                            tilePadding: EdgeInsets.symmetric(
                                              horizontal: _s(16, scale),
                                              vertical: _s(12, scale),
                                            ),
                                            childrenPadding: EdgeInsets.symmetric(
                                              horizontal: _s(16, scale),
                                              vertical: _s(8, scale),
                                            ),
                                            collapsedIconColor: titleColor,
                                            iconColor: titleColor,
                                            title: Text(
                                              _faqItems[i]['q'] ?? '',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                fontSize: _s(18, scale),
                                                color: Colors.black,
                                              ),
                                            ),
                                            children: [
                                              Text(
                                                _faqItems[i]['a'] ?? '',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: _s(16, scale),
                                                  height: 1.4,
                                                  color: bodyTextColor,
                                                ),
                                              ),
                                              SizedBox(height: _s(8, scale)),
                                            ],
                                          ),
                                        ),

                                        // Divider mimic (background: #D7DEF0)
                                        if (i != _faqItems.length - 1)
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: _s(16, scale)),
                                            child: Container(
                                              height: 1,
                                              color: dividerColor,
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),

                                SizedBox(height: _s(24, scale)),

                                // Example framed blocks (Frame 36795/36796 etc. — placeholders)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(_s(8, scale)),
                                  ),
                                  padding: EdgeInsets.all(_s(16, scale)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mais informações',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: _s(18, scale),
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: _s(12, scale)),
                                      Text(
                                        'Aqui você pode incluir detalhes sobre processos, políticas e contatos úteis relacionados ao serviço de reciclagem.',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: _s(16, scale),
                                          height: 1.4,
                                          color: bodyTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: _s(40, scale)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}