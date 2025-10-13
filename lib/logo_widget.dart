import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/logo.svg',
      width: width ?? 248, // valor padrão 248 se não for especificado
      height: height ?? 76, // valor padrão 76 se não for especificado
    );
  }
}