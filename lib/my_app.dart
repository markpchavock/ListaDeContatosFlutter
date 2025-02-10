
import 'package:app_lista_de_contatos/pages/splash_screen_contatos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(ThemeData.light()
            .textTheme
            .copyWith(bodyMedium: TextStyle(color: Colors.white))),
        appBarTheme: AppBarTheme(color: const Color.fromARGB(255, 49, 48, 48)),
      ),
    );
  }
}
