import 'package:flutter/material.dart';

class TermsServicePage extends StatelessWidget {
  const TermsServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                // Barra superior
                Container(
                  height: 64,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Positioned(
                        left: isDesktop ? 16 : 0, // seta mais encostada no mobile
                        top: 8,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 28),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      // Título
                      Center(
                        child: Text(
                          "Termos de Serviço",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: isDesktop ? 34 : 26,
                            color: const Color(0xFF079121),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Linha separadora
                Container(
                  height: 66,
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Termos & Condições",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: isDesktop ? 20 : 16,
                      color: const Color(0xFF079121),
                    ),
                  ),
                ),

                // Conteúdo
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      '''
Ao baixar ou usar o aplicativo, estes termos serão aplicados automaticamente a você – certifique-se, portanto, de lê-los com atenção antes de utilizar o app. Não é permitido copiar ou modificar o aplicativo, qualquer parte dele ou nossas marcas registradas de nenhuma forma. Também não é permitido tentar extrair o código-fonte do app, traduzi-lo para outros idiomas ou criar versões derivadas. O aplicativo, bem como todas as marcas, direitos autorais, direitos sobre bases de dados e demais direitos de propriedade intelectual a ele relacionados permanecem de titularidade exclusiva da RIA Green Tecnologia Sustentável LTDA.
A RIA Green compromete-se a manter o aplicativo tão útil e eficiente quanto possível. Por esse motivo, reservamo-nos o direito de alterar o app ou cobrar por seus serviços, a qualquer momento e por qualquer razão. Nunca cobraremos pelo aplicativo ou por seus serviços sem deixar claro exatamente o que está sendo cobrado.
O aplicativo RIA Green armazena e processa dados pessoais fornecidos por você para prestar nosso Serviço. É sua responsabilidade manter seu telefone e o acesso ao app seguros. Assim, recomendamos que você não faça jailbreak ou root em seu dispositivo, pois isso pode deixá-lo vulnerável a malware/ vírus/ programas maliciosos, comprometer seus recursos de segurança e impedir que o aplicativo funcione corretamente.
O app utiliza serviços de terceiros que possuem seus próprios Termos e Condições.Links para os Termos e Condições dos provedores terceiros utilizados pelo app:

Google Play Services
AdMob
Google Analytics for Firebase
Firebase Crashlytics
Facebook

Tenha em mente que há determinadas situações pelas quais a RIA Green não se responsabiliza. Certas funções do app exigem conexão ativa à internet. A conexão pode ser Wi-Fi ou rede móvel; contudo, a RIA Green não se responsabiliza por funcionamento parcial ou interrupções se você não tiver Wi-Fi nem franquia de dados disponível.
Se você usar o app fora de uma área com Wi-Fi, o contrato com sua operadora móvel continuará válido. Assim, poderão ser cobrados custos de dados durante o uso do aplicativo, inclusive tarifas de roaming em outro país ou região. Ao utilizar o app, você aceita a responsabilidade por tais cobranças. Se não for o pagador da conta do dispositivo, presumimos que tem autorização do responsável financeiro para utilizar o aplicativo.
Da mesma forma, a RIA Green não se responsabiliza pelo modo como você utiliza o app. É sua obrigação manter o dispositivo carregado; se a bateria acabar e você não conseguir utilizar o Serviço, a responsabilidade não será da RIA Green.
Embora nos esforcemos para manter o aplicativo sempre atualizado e correto, dependemos de terceiros para certas informações. A RIA Green não se responsabiliza por perdas, diretas ou indiretas, resultantes de confiança exclusiva nessas funcionalidades.

Conformidade Ambiental
O usuário compromete-se a descartar equipamentos eletroeletrônicos conforme a legislação brasileira de resíduos: Lei 12.305/2010 – PNRS, Decreto 10.240/2020 (logística reversa de eletroeletrônicos) e demais normas aplicáveis. (planalto.gov.br, planalto.gov.br) Os pontos de entrega voluntária (PEVs) e operadores autorizados listados no app devem ser utilizados para garantir o descarte ambientalmente adequado.
Proteção de Dados
O tratamento dos seus dados segue a Lei 13.709/2018 – LGPD. (planalto.gov.br)

Atualizações e Término de Uso
Eventualmente poderemos atualizar o app. Os requisitos do sistema (iOS ou outros) podem mudar e será necessário instalar atualizações para continuar usando o aplicativo. A RIA Green não garante que sempre atualizará o app para torná-lo compatível com a versão do sistema operacional em seu dispositivo. Você concorda em aceitar atualizações oferecidas. Podemos também interromper o fornecimento do app e encerrar seu uso a qualquer momento, sem aviso prévio. Salvo indicação em contrário, após qualquer término: (a) os direitos e licenças concedidos nestes termos cessarão; (b) você deverá parar de usar o app e, se necessário, excluí-lo do dispositivo.

Alterações nestes Termos e Condições
Poderemos atualizar estes Termos periodicamente. Recomendamos revisitar esta página para verificar mudanças. Quaisquer alterações serão publicadas aqui.
Estes Termos e Condições são válidos a partir de 09/10/2022.

Contato
Dúvidas ou sugestões sobre estes Termos e Condições? Fale conosco: suporte@riagreen.com.br.
                      ''',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: isDesktop ? 16 : 12,
                        height: 1.5,
                        color: const Color(0xFF1E1E1E),
                      ),
                      textAlign: TextAlign.justify,
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
}
