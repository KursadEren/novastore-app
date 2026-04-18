import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novastore/components/bottom_bar.dart';

Future<void> main() async {
  // .env dosyasını yükle
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NovaStore',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const BottomBar(),
    );
  }
}