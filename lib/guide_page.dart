// lib/guide_page.dart
import 'dart:math';
import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  // Conteúdo genérico do guia (substitua pelo texto real quando quiser)
  static final List<Map<String, String>> _guideSections = [
    {
      'title': 'O que é este app?',
      'body':
          'Este aplicativo ajuda você a localizar pontos de coleta, ganhar pontos e trocar por recompensas. O objetivo é facilitar a reciclagem na sua cidade.'
    },
    {
      'title': 'Como reciclar corretamente?',
      'body':
          'Separe os materiais por tipo (plástico, vidro, papel, metal). Limpe resíduos orgânicos e verifique se o ponto de coleta aceita o material antes de entregar.'
    },
    {
      'title': 'Como usar o mapa de pontos?',
      'body':
          'Abra "Pontos de coleta", filtre por material aceito e clique no marcador para ver detalhes e horário de funcionamento.'
    },
    {
      'title': 'Como ganhar pontos?',
      'body':
          'Registre entregas feitas em pontos parceiros e complete missões dentro do app. Seus pontos aparecem no painel principal.'
    },
    {
      'title': 'Dicas rápidas',
      'body':
          'Aproveite campanhas locais, leve sacos reutilizáveis e verifique orientações locais para descarte de eletrônicos e pilhas.'
    },
  ];

  // Base artboard for scaling
  static const double _baseWidth = 430.0;
  static const double _baseHeight = 932.0;

  double _s(double value, double scale) => value * scale;

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    // Use the smaller ratio to preserve proportions like in your design
    final double scale = [screen.width / _baseWidth, screen.height / _baseHeight].reduce(min);

    // Design tokens
    final Color bgColor = const Color(0xFFF4F5F9); // #F4F5F9
    final Color titleColor = const Color(0xFF1279A9); // #1279A9
    final Color dividerColor = const Color(0xFFD7DEF0); // #D7DEF0
    final Color bodyTextColor = const Color.fromRGBO(60, 60, 67, 0.85);

    // Layout measurements from your CSS (converted)
    final double topBarHeight = _s(120, scale);
    final double titleFontSize = _s(32, scale);
    final double imageLeft = _s(34, scale); // left:34 in CSS
    final double imageTopFromArtboard = _s(134, scale); // top:134
    final double imageDesignWidth = _s(362, scale); // width:362
    final double imageDesignHeight = _s(259, scale); // height:259
    final double questionsLeft = _s(27, scale); // left:27 from Questions block
    final double contentMaxWidth = min(screen.width - _s(34, scale), _s(397, scale));

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar (Rectangle 1443)
            Container(
              height: topBarHeight,
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: _s(16, scale)),
              child: Stack(
                children: [
                  // Back arrow left
                  Positioned(
                    left: _s(29, scale),
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

                  // Title "Guia" centered vertically
                  Positioned(
                    top: _s(40, scale),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Guia',
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

            // Body: scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: LayoutBuilder(builder: (context, constraints) {
                  final double horizontalGutter = max((constraints.maxWidth - contentMaxWidth) / 2, _s(12, scale));
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
                        // Image block ("Untitled design 1") positioned like left:34 top:134
                        Padding(
                          padding: EdgeInsets.only(left: imageLeft),
                          child: Container(
                            width: min(imageDesignWidth, contentMaxWidth - imageLeft),
                            height: imageDesignHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_s(8, scale)),
                              image: const DecorationImage(
                                image: AssetImage('images/guide_image.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: _s(24, scale)),

                        // Questions / Guide content block
                        Padding(
                          padding: EdgeInsets.only(left: questionsLeft, right: questionsLeft),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: contentMaxWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title area
                                Padding(
                                  padding: EdgeInsets.only(bottom: _s(24, scale)),
                                  child: Text(
                                    'Guia de Uso',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: _s(24, scale),
                                      height: 1.2,
                                      color: titleColor,
                                    ),
                                  ),
                                ),

                                // Primary accordion block (mimics your CSS structure)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(_s(8, scale)),
                                  ),
                                  child: Column(
                                    children: [
                                      for (int i = 0; i < _guideSections.length; i++) ...[
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
                                              _guideSections[i]['title'] ?? '',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                fontSize: _s(18, scale),
                                                color: Colors.black,
                                              ),
                                            ),
                                            children: [
                                              Text(
                                                _guideSections[i]['body'] ?? '',
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
                                        if (i != _guideSections.length - 1)
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: _s(16, scale)),
                                            child: Container(height: 1, color: dividerColor),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),

                                SizedBox(height: _s(24, scale)),

                                // Frame 36796 / additional content placeholders to match vertical length from your CSS
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
                                        'Recursos e atalhos',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: _s(18, scale),
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: _s(12, scale)),
                                      Text(
                                        'Use a busca para encontrar tópicos rapidamente. Salve artigos que achar úteis e acompanhe novidades no painel principal.',
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

                                SizedBox(height: _s(32, scale)),
                                // final spacer
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: _s(40, scale)),
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