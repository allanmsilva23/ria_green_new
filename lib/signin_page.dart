import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool loading = false;

  final storage = const FlutterSecureStorage();

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "25880375803-qcsgssv736dp3i7f0327lag5sknhi760.apps.googleusercontent.com",
    scopes: const ['email', 'profile', 'openid'],
  );

  // ---- Login com Email ----
  Future<void> _loginEmail() async {
    if (_email.text.isEmpty || _senha.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha email e senha")),
      );
      return;
    }

    setState(() => loading = true);
    try {
      final res = await http.post(
        Uri.parse("https://ria-green-backend-674627922547.southamerica-east1.run.app/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
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
        String msg = data['error'] ?? "Erro desconhecido";
        if (msg.contains("não encontrado")) {
          msg = "Usuário não cadastrado. Faça o cadastro.";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  // ---- Login com Google ----
  Future<void> _loginGoogle() async {
    setState(() => loading = true);
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Google cancelado")),
        );
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null && accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro: Google não retornou tokens.")),
        );
        return;
      }

      final res = await http.post(
        Uri.parse("https://ria-green-backend-674627922547.southamerica-east1.run.app/login-google"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": googleUser.email,
          "id_token": idToken,
          "access_token": accessToken,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        await storage.write(key: "token", value: data['token']);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        String msg = data['error'] ?? "Erro desconhecido";
        if (msg.contains("não encontrado")) {
          msg = "Usuário não cadastrado. Faça o cadastro.";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro login Google: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  // ---- UI ----
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
                      // Voltar
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
                            'Bem vindo de volta',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: fs(30),
                              color: const Color(0xFF00336D),
                            ),
                          ),
                        ),
                      ),
                      // Botão Google
                      Positioned(
                        top: fh(295),
                        left: cx(fw(374)),
                        child: GestureDetector(
                          onTap: loading ? null : _loginGoogle,
                          child: _socialButton(
                            width: fw(374),
                            height: fh(55),
                            radius: 12 * r,
                            iconPath: 'assets/svg/google.svg',
                            iconSize: 22 * r,
                            bgColor: Colors.transparent,
                            borderColor: const Color(0xFF1E1E1E),
                            text: 'Entrar com GOOGLE',
                            textSize: fs(14),
                            textColor: const Color(0xFF1E1E1E),
                            gap: fw(20),
                            paddingLeft: fw(20),
                            borderWidth: r,
                          ),
                        ),
                      ),
                      // Texto divisor
                      Positioned(
                        top: fh(390),
                        left: 0,
                        right: 0,
                        child: Text(
                          'ou ENTRE COM E-MAIL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: fs(14),
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ),
                      // Email
                      Positioned(
                        top: fh(450),
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
                      // Senha
                      Positioned(
                        top: fh(520),
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
                      // Entrar
                      Positioned(
                        top: fh(600),
                        left: cx(fw(374)),
                        child: GestureDetector(
                          onTap: loading ? null : _loginEmail,
                          child: Container(
                            width: fw(374),
                            height: fh(55),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00336D),
                              borderRadius: BorderRadius.circular(12 * r),
                            ),
                            alignment: Alignment.center,
                            child: loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Entrar",
                                    style: TextStyle(
                                      fontSize: isMobile ? 16 : 20, // maior no desktop
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      // Cadastro link
                      Positioned(
                        top: fh(700),
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, "/signup"),
                          child: Text(
                            "Não tem conta? Cadastre-se",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 16, // maior no desktop
                              color: const Color(0xFF4C4C4C),
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

  // ----- Widgets auxiliares -----
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
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          hintStyle: TextStyle(
            fontSize: textSize,
            color: const Color(0xFF3F414E),
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
          ),
          SizedBox(width: gap),
          Text(
            text,
            style: TextStyle(
              fontSize: textSize,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}