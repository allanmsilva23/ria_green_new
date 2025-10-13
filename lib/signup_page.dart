import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool aceitouPolitica = false;
  bool loading = false;

  final storage = const FlutterSecureStorage();

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "25880375803-qcsgssv736dp3i7f0327lag5sknhi760.apps.googleusercontent.com",
    scopes: const ['email', 'profile', 'openid'], // inclui openid
  );

  // ---------------- Funções ----------------
  Future<void> _signUp() async {
    if (_nome.text.isEmpty ||
        _email.text.isEmpty ||
        _senha.text.isEmpty ||
        !aceitouPolitica) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente")),
      );
      return;
    }

    setState(() => loading = true);
    try {
      final res = await http.post(
        Uri.parse("https://ria-green-backend-674627922547.southamerica-east1.run.app/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nome": _nome.text,
          "email": _email.text,
          "senha": _senha.text,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await storage.write(key: "token", value: data['token']);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro: ${data['error']}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _signUpGoogle() async {
    setState(() => loading = true);
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login Google cancelado")));
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken; // pode ser null no Web
      final accessToken = googleAuth.accessToken; // geralmente vem no Web

      if (idToken == null && accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Não recebi idToken nem accessToken do Google"),
          ),
        );
        return;
      }

      final userName =
          (googleUser.displayName != null &&
              googleUser.displayName!.trim().isNotEmpty)
          ? googleUser.displayName!
          : "Usuário Google";

      final payload = {
        "nome": userName,
        "email": googleUser.email,
        "provider": "google",
        if (idToken != null) "id_token": idToken,
        if (accessToken != null) "access_token": accessToken,
      };

      final res = await http.post(
        Uri.parse("https://ria-green-backend-674627922547.southamerica-east1.run.app/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await storage.write(key: "token", value: data['token']);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro backend: ${data['error']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro login Google: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  // ---------------- Build ----------------
  @override
  Widget build(BuildContext context) {
    const baseW = 430.0;
    const baseH = 932.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final isMobile = maxW <= 600;

            final contentW = isMobile ? maxW : maxW.clamp(500.0, 700.0);
            final contentH = isMobile ? baseH : constraints.maxHeight;

            final sx = contentW / baseW;
            final sy = contentH / baseH;
            final r = sx < sy ? sx : sy;

            double cx(double w) => (contentW - w) / 2;
            double fw(double v) => v * sx;
            double fh(double v) => v * sy;
            double fs(double v) => v * r;

            return Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: contentW,
                  height: contentH,
                  child: Stack(
                    children: [
                      // Botão voltar
                      Positioned(
                        left: fw(28),
                        top: fh(40),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: fw(55),
                            height: fh(55),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF00336D),
                                width: r,
                              ),
                              borderRadius: BorderRadius.circular(38 * r),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: const Color(0xFF00336D),
                              size: fs(24),
                            ),
                          ),
                        ),
                      ),
                      // Logo
                      Positioned(
                        top: fh(122),
                        left: cx(fw(192)),
                        child: SizedBox(
                          width: fw(192),
                          height: fh(59),
                          child: SvgPicture.asset(
                            'assets/svg/logo.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Título
                      Positioned(
                        top: fh(217),
                        left: cx(fw(323)),
                        child: SizedBox(
                          width: fw(323),
                          child: Text(
                            'Crie sua conta',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: fs(30),
                              height: 1.35,
                              color: const Color(0xFF00336D),
                            ),
                          ),
                        ),
                      ),

                      // Botão Google (AGORA EM CIMA)
                      Positioned(
                        top: fh(280),
                        left: cx(fw(374)),
                        child: GestureDetector(
                          onTap: loading ? null : _signUpGoogle,
                          child: _socialButton(
                            width: fw(374),
                            height: fh(55),
                            radius: 12 * r,
                            iconPath: 'assets/svg/google.svg',
                            iconSize: 22 * r,
                            bgColor: Colors.transparent,
                            borderColor: const Color(0xFF1E1E1E),
                            text: 'Cadastrar com GOOGLE',
                            textSize: fs(14),
                            textColor: const Color(0xFF1E1E1E),
                            gap: fw(20),
                            paddingLeft: fw(20),
                            borderWidth: r,
                          ),
                        ),
                      ),

                      // --- Divisor texto ---
                      Positioned(
                        top: fh(355),
                        left: 0,
                        right: 0,
                        child: Text(
                          'ou ENTRE COM E-MAIL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: fs(14),
                            letterSpacing: 0.05,
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ),

                      // Inputs
                      Positioned(
                        top: fh(390),
                        left: cx(fw(374)),
                        child: _inputBox(
                          controller: _nome,
                          width: fw(374),
                          height: fh(55),
                          radius: 12 * r,
                          paddingH: fw(16),
                          text: "Nome completo",
                          textSize: fs(14),
                        ),
                      ),
                      Positioned(
                        top: fh(460),
                        left: cx(fw(374)),
                        child: _inputBox(
                          controller: _email,
                          width: fw(374),
                          height: fh(55),
                          radius: 12 * r,
                          paddingH: fw(16),
                          text: "Email",
                          textSize: fs(14),
                        ),
                      ),
                      Positioned(
                        top: fh(530),
                        left: cx(fw(374)),
                        child: _inputBox(
                          controller: _senha,
                          width: fw(374),
                          height: fh(55),
                          radius: 12 * r,
                          paddingH: fw(16),
                          text: "Senha",
                          textSize: fs(14),
                          obscureText: true,
                        ),
                      ),

                      // Checkbox
                      Positioned(
                        top: fh(600),
                        left: cx(fw(374)),
                        child: Row(
                          children: [
                            Checkbox(
                              value: aceitouPolitica,
                              activeColor: const Color(0xFF00336D), // cor quando marcado
                              checkColor: Colors.white,             // cor do "check"
                              onChanged: (val) {
                                setState(() => aceitouPolitica = val ?? false);
                              },
                            ),
                            Text(
                              "Aceito a política de privacidade",
                              style: TextStyle(
                                fontSize: fs(12),
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botão cadastrar
                      Positioned(
                        top: fh(650),
                        left: cx(fw(374)),
                        child: GestureDetector(
                          onTap: loading ? null : _signUp,
                          child: Container(
                            width: fw(374),
                            height: fh(55),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00336D),
                              borderRadius: BorderRadius.circular(12 * r),
                            ),
                            alignment: Alignment.center,
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Cadastrar",
                                    style: TextStyle(
                                      fontSize: fs(16),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- Widgets auxiliares ----------------
  static Widget _inputBox({
    required TextEditingController controller,
    required double width,
    required double height,
    required double radius,
    required double paddingH,
    required String text,
    required double textSize,
    bool obscureText = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.symmetric(horizontal: paddingH),
      child: Center(
        // <-- garante centralização vertical
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          textAlignVertical: TextAlignVertical.center, // centralizado
          decoration: InputDecoration(
            isCollapsed: true, // remove padding extra
            border: InputBorder.none,
            hintText: text,
            hintStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              fontSize: textSize,
              color: const Color(0xFF3F414E),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _socialButton({
    required double width,
    required double height,
    required double radius,
    required String iconPath,
    required double iconSize,
    Color? iconColor,
    required Color bgColor,
    required Color? borderColor,
    required String text,
    required double textSize,
    required Color textColor,
    required double gap,
    required double paddingLeft,
    required double borderWidth,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: Row(
        children: [
          SizedBox(width: paddingLeft),
          SvgPicture.asset(
            iconPath,
            height: iconSize,
            width: iconSize,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                : null,
          ),
          SizedBox(width: gap),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              fontSize: textSize,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}