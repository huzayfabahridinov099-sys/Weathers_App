import 'package:flutter/material.dart';
import 'package:weathers_1/page/home_page.dart';
import 'package:weathers_1/page/solech_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SolechPage(),
    );
  }
}
