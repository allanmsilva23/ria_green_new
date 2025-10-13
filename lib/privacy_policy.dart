import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                          "Política de Privacidade",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: isDesktop ? 34 : 26,
                            color: const Color(0xFFF12C36),
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
                    "Política de Privacidade Ria Green",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: isDesktop ? 20 : 16,
                      color: const Color(0xFFF12C36),
                    ),
                  ),
                ),

                // Conteúdo
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      '''
A RIA Green Tecnologia Sustentável LTDA. desenvolveu o aplicativo RIA Green como um aplicativo comercial. Este Serviço é fornecido pela RIA Green e está disponível para uso “como está”.
Esta página tem como finalidade informar os usuários sobre nossas políticas quanto à coleta, uso e divulgação de Informações Pessoais, caso alguém decida utilizar o nosso Serviço.
Ao optar por utilizar o Serviço, você concorda com a coleta e uso de informações conforme descrito nesta política. As Informações Pessoais que coletamos são utilizadas para fornecer e melhorar o Serviço. Não utilizaremos nem compartilharemos suas informações com terceiros, exceto conforme descrito nesta Política de Privacidade.
Os termos usados nesta política têm o mesmo significado definido em nossos Termos e Condições, disponíveis dentro do aplicativo, salvo indicação em contrário.
Coleta e Uso de Informações
Para uma melhor experiência com nosso Serviço, podemos solicitar que você forneça certas informações pessoalmente identificáveis, incluindo, mas não se limitando a: nome, idade, dados de contato, localização e endereço IP. Essas informações serão armazenadas e utilizadas conforme esta política.
O aplicativo utiliza serviços de terceiros que também podem coletar informações capazes de identificar você.Links para a política de privacidade de terceiros utilizados pelo app:

Google Play Services
AdMob
Google Analytics for Firebase
Firebase Crashlytics
Facebook

Dados de Registro (Log Data)
Sempre que você utiliza nosso Serviço e ocorre um erro no aplicativo, coletamos dados e informações (via produtos de terceiros) do seu dispositivo, conhecidos como Log Data. Isso pode incluir: endereço IP, nome do dispositivo, versão do sistema operacional, configurações do app no momento da falha, data e hora de uso, entre outros dados técnicos.

Cookies
Cookies são arquivos com pequenas quantidades de dados, frequentemente utilizados como identificadores anônimos. Eles são enviados para o navegador a partir de sites visitados e armazenados na memória do seu dispositivo.
Este aplicativo não utiliza cookies diretamente. No entanto, o app pode incorporar bibliotecas e códigos de terceiros que utilizam cookies para coleta de dados e aprimoramento de serviços. Você pode aceitar ou recusar os cookies, ou ser notificado ao receber um. Recusar cookies pode afetar algumas funcionalidades do app.
Prestadores de Serviço
Podemos contratar empresas e pessoas físicas terceirizadas para:

Facilitar o nosso Serviço;
Fornecer o Serviço em nosso nome;
Realizar serviços relacionados ao app;
Ajudar na análise de uso do nosso Serviço.

Esses terceiros podem ter acesso às suas Informações Pessoais, apenas para executar as funções atribuídas a eles e sob a obrigação de não divulgar ou usar tais informações para outros fins.

Segurança
Valorizamos sua confiança ao nos fornecer suas Informações Pessoais, e por isso buscamos aplicar meios comercialmente aceitáveis de protegê-las. No entanto, nenhum método de transmissão pela internet ou armazenamento eletrônico é 100% seguro. Não podemos garantir segurança absoluta.
Links para Outros Sites
Este app pode conter links para sites de terceiros. Ao clicar em um link externo, você será direcionado para um site fora do controle da RIA Green. Recomendamos que você leia a política de privacidade desses sites, pois não temos controle nem assumimos responsabilidade sobre o conteúdo, práticas ou políticas de terceiros.

Privacidade de Crianças
Este Serviço não é destinado a menores de 13 anos. Não coletamos, de forma consciente, informações pessoais de crianças dessa faixa etária. Caso descubramos que um menor de 13 anos nos forneceu dados pessoais, esses dados serão apagados imediatamente de nossos servidores. Se você é pai, mãe ou responsável e sabe que seu filho nos forneceu dados, entre em contato para tomarmos as devidas providências.
Alterações nesta Política de Privacidade
Podemos atualizar nossa Política de Privacidade periodicamente. Recomendamos revisar esta página com frequência. Notificaremos quaisquer mudanças publicando a nova versão nesta página.
Esta política é válida a partir de 09/10/2022.

Fale Conosco
Caso tenha dúvidas ou sugestões sobre esta Política de Privacidade, entre em contato: suporte@riagreen.com.br.
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
