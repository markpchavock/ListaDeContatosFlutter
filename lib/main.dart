import 'package:app_lista_de_contatos/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "config.env");
  runApp(const MyApp());
  
}
