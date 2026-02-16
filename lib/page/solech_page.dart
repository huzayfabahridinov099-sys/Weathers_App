import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weathers_1/page/weather_page.dart';

class SolechPage extends StatefulWidget {
  const SolechPage({super.key});

  @override
  _SolechPageState createState() => _SolechPageState();
}

class _SolechPageState extends State<SolechPage> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WeatherPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/7.png',
            fit: BoxFit.cover,
          ),
        
        ],
      ),
    );
  }
}