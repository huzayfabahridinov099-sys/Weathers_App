import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final cityController = TextEditingController();

  double? temp;
  double? feelsLike;
  String weatherMain = '';
  String weatherIcon = '';
  List hourlyList = [];

  static const String apiKey = "cb48ef63d0ca9a502f56f88de0c1ed5d";
  static const String baseUrl =
      "https://api.openweathermap.org/data/2.5";

  Future<void> getWeather() async {
    final city = cityController.text.trim();
    if (city.isEmpty) return;

    final weatherUri = Uri.parse(
        '$baseUrl/weather?q=$city&appid=$apiKey&units=metric');

    final weatherRes = await http.get(weatherUri);

    if (weatherRes.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Город не найден")),
      );
      return;
    }

    final weatherData = jsonDecode(weatherRes.body);

    final forecastUri = Uri.parse(
        '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric');

    final forecastRes = await http.get(forecastUri);
    if (forecastRes.statusCode != 200) return;

    final forecastData = jsonDecode(forecastRes.body);

    setState(() {
      temp = (weatherData['main']['temp'] as num).toDouble();
      feelsLike =
          (weatherData['main']['feels_like'] as num).toDouble();
      weatherMain = weatherData['weather'][0]['main'];
      weatherIcon = weatherData['weather'][0]['icon'];
      hourlyList = forecastData['list'].take(6).toList();
    });
  }

  String getWeekday(int weekday) {
    const days = [
      "Понедельник",
      "Вторник",
      "Среда",
      "Четверг",
      "Пятница",
      "Суббота",
      "Воскресенье"
    ];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              "assets/images/1.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade800
                          .withOpacity(0.9),
                      borderRadius:
                          BorderRadius.circular(40),
                    ),
                    child: TextField(
                      controller: cityController,
                      style:
                          const TextStyle(color: Colors.white),
                      onSubmitted: (_) => getWeather(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Введите город",
                        hintStyle: const TextStyle(
                            color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search,
                              color: Colors.white),
                          onPressed: getWeather,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          if (temp != null) ...[

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Сейчас",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "${temp!.round()}°",
                                      style:
                                          const TextStyle(
                                        fontSize: 80,
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Image.network(
                                      "https://openweathermap.org/img/wn/$weatherIcon@2x.png",
                                      width: 60,
                                    ),
                                    Text(
                                      weatherMain,
                                      style:
                                          const TextStyle(
                                        fontSize: 22,
                                        color:
                                            Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Feels like ${feelsLike?.round()}°",
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white70,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              getWeekday(
                                  DateTime.now()
                                      .weekday),
                              style: const TextStyle(
                                  color:
                                      Colors.white),
                            ),
                            Text(
                              "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
                              style: const TextStyle(
                                  color:
                                      Colors.white70),
                            ),
                            Text(
                              TimeOfDay.now()
                                  .format(context),
                              style: const TextStyle(
                                  color:
                                      Colors.white70),
                            ),

                            const SizedBox(height: 30),

                            /// HOURLY
                            if (hourlyList.isNotEmpty)
                              Container(
                                padding:
                                    const EdgeInsets.all(
                                        20),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .brown.shade900
                                      .withOpacity(
                                          0.95),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              30),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Text(
                                      "Почасовой прогноз",
                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .white,
                                        fontSize:
                                            20,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 20),
                                    SingleChildScrollView(
                                      scrollDirection:
                                          Axis
                                              .horizontal,
                                      child: Row(
                                        children:
                                            hourlyList
                                                .map(
                                                    (item) {
                                          final time =
                                              item['dt_txt']
                                                  .toString()
                                                  .substring(
                                                      11,
                                                      16);
                                          final hourTemp =
                                              item['main']
                                                      [
                                                      'temp']
                                                  .round();
                                          final icon =
                                              item['weather']
                                                      [0]
                                                  ['icon'];

                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    right:
                                                        20),
                                            child:
                                                Column(
                                              children: [
                                                Text(
                                                  "$hourTemp°",
                                                  style:
                                                      const TextStyle(
                                                    color:
                                                        Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height:
                                                        8),
                                                Image.network(
                                                  "https://openweathermap.org/img/wn/$icon@2x.png",
                                                  width:
                                                      40,
                                                ),
                                                const SizedBox(
                                                    height:
                                                        8),
                                                Text(
                                                  time,
                                                  style:
                                                      const TextStyle(
                                                    color:
                                                        Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 30),

                            Container(
                              padding:
                                  const EdgeInsets.all(
                                      20),
                              decoration: BoxDecoration(
                                color: Colors
                                    .brown.shade900
                                    .withOpacity(
                                        0.95),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            30),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  const Text(
                                    "Прогноз погоды на 7 дней",
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                          20,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 15),

                                  ...List.generate(
                                      7,
                                      (index) {
                                    final day =
                                        DateTime
                                            .now()
                                            .add(
                                                Duration(
                                                    days:
                                                        index));

                                    return Padding(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              vertical:
                                                  8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getWeekday(
                                                day
                                                    .weekday),
                                            style:
                                                const TextStyle(color: Colors.white),
                                          ),
                                          const Icon(
                                              Icons
                                                  .cloud,
                                              color:
                                                  Colors.white70),
                                          Text(
                                            "${temp!.round() - index}°",
                                            style:
                                                const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
