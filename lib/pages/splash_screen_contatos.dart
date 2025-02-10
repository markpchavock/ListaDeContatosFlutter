import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_lista_de_contatos/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 148, 144, 144),
            const Color.fromARGB(255, 34, 33, 33)
          ],
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.userGroup, size: 70),
              SizedBox(
                height: 20,
              ),
              AnimatedTextKit(
                onFinished: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => MainPage()));
                },
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Contatos',
                    textStyle: GoogleFonts.lato().copyWith(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w900,
                    ),
                    speed: const Duration(milliseconds: 200), // 80
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 1000), // 300
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
