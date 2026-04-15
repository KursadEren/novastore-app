import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novastore/components/my_button.dart';
import 'package:novastore/pages/home_screen.dart';

Future<void> main() async {
  // .env dosyasını yükle
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp
    (home: HomeScreen(),);
  }
}