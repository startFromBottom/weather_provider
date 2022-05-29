// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:weather_provider/constants/constants.dart';
import 'package:weather_provider/exceptions/weather_exception.dart';
import 'package:weather_provider/services/http_error_handler.dart';

class WeatherApiServices {
  final http.Client httpClient;
  WeatherApiServices({
    required this.httpClient,
  });

  Future<int> getWoeid(String city) async {
    final Uri uri = Uri(
      scheme: "https",
      host: kHost,
      path: "/api/location/search",
      queryParameters: {
        "query": "city",
      },
    );

    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw WeatherException("Cannot get the woeid of $city");
      }

      if (responseBody.length > 1) {
        throw WeatherException(
            "There are multiple candidates for city, please specify further!");
      }

      return responseBody[0]["woeid"];
    } catch (e) {
      rethrow;
    }
  }
}
