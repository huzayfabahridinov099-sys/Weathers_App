import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weathers_1/widget/weather_result.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final String apiKey = '9207160f14b4a80aa257790e2396362a';

  bool isLoading = false;
  String city = '';
  String temp = '';
  String description = '';
  String error = '';

  Future<void> getWeather() async {
    final cityInput = cityController.text.trim();
    final countryInput = countryController.text.trim().toUpperCase();

    if (cityInput.isEmpty) {
      setState(() {
        error = 'Введите город';
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    final query =
        countryInput.isEmpty ? cityInput : '$cityInput,$countryInput';

    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {
        'q': query,
        'appid': apiKey,
        'units': 'metric',
        'lang': 'ru',
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          city = '${data['name']}, ${data['sys']['country']}';
          temp = '${data['main']['temp']} °C';
          description = data['weather'][0]['description'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Город не найден';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Ошибка сети';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Город (например: Osh)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(
                labelText: 'Код страны (KG, RU — необязательно)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: getWeather,
                child: const Text('Показать погоду'),
              ),
            ),
            const SizedBox(height: 30),
            if (isLoading) const CircularProgressIndicator(),
            if (error.isNotEmpty)
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            if (!isLoading && error.isEmpty && temp.isNotEmpty)
              WeatherResult(
                city: city,
                temp: temp,
                description: description,
              ),
          ],
        ),
      ),
    );
  }
}
