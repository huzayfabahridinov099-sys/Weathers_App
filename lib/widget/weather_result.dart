import 'package:flutter/material.dart';

class WeatherResult extends StatelessWidget {
  final String city;
  final String temp;
  final String description;

  const WeatherResult({
    Key? key,
    required this.city,
    required this.temp,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          city,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          temp,
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
