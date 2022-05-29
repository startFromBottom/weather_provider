import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;

import 'package:weather_provider/pages/home_page.dart';
import 'package:weather_provider/providers/weather_provider.dart';
import 'package:weather_provider/repositories/weather_repository.dart';
import 'package:weather_provider/services/weather_api_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>(
          create: (context) {
            final WeatherApiServices weatherApiServices = WeatherApiServices(
              httpClient: http.Client(),
            );
            return WeatherRepository(weatherApiServices: weatherApiServices);
          },
        ),
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(
            weatherRepository: context.read<WeatherRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Weather Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
