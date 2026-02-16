import 'package:flutter/material.dart';

class WeatherResult extends StatelessWidget {
  final double temp;
  final String description;
  final String weatherMain;

  const WeatherResult({
    super.key,
    required this.temp,
    required this.description,
    required this.weatherMain,
  });

  String getWeatherImage() {
    switch (weatherMain) {
      case 'Clear':
        return 'assets/images/qu5.png';
      case 'Clouds':
        return 'assets/images/b2.png';
      case 'Rain':
        return 'assets/images/y6.png';
      case 'Snow':
        return 'assets/images/q4.png';
      case 'Thunderstorm':
        return 'assets/images/c3.png';
      default:
        return 'assets/images/b2.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          getWeatherImage(),
          width: 120,
        ),
        const SizedBox(height: 10),
        Text(
          '${temp.toStringAsFixed(1)} °C',
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }
}
