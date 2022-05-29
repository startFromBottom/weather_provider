import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import 'package:weather_provider/pages/search_page.dart';
import 'package:weather_provider/providers/weather_provider.dart';
import 'package:weather_provider/repositories/weather_repository.dart';
import 'package:weather_provider/services/weather_api_services.dart';
import 'package:weather_provider/widgets/error_dialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  late final WeatherProvider _weatherProv;

  @override
  void initState() {
    super.initState();
    _weatherProv = context.read<WeatherProvider>();
    _weatherProv.addListener(_registerListener);
  }

  @override
  void dispose() {
    _weatherProv.removeListener(_registerListener);
    super.dispose();
  }

  void _registerListener() {
    final WeatherState ws = context.read<WeatherProvider>().state;

    if (ws.status == WeatherStatus.error) {
      errorDialog(context, ws.error.errMsg);
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchWeather();
  // }

  // _fetchWeather() {
  //   /// repository를 직접 호출하지 않고 provider 사용 시 감싸지 않으면 에러 발생.
  //   /// repository는 widget tree와 관련이 없으나, provider는 관련이 있기 때문.
  //   ///
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     context.read<WeatherProvider>().fetchWeather("London");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SearchPage();
                  },
                ),
              );
              print("city: $_city");
              if (_city != null) {
                context.read<WeatherProvider>().fetchWeather(_city!);
              }
            },
          )
        ],
      ),
      body: _showWeather(),
    );
  }

  Widget _showWeather() {
    final weatherState = context.watch<WeatherProvider>().state;
    if (weatherState.status == WeatherStatus.initial ||
        (weatherState.status == WeatherStatus.error &&
            weatherState.weather.title.isEmpty)) {
      return Center(
        child: Text(
          "Select a city",
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }

    if (weatherState.status == WeatherStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    // status = error -> addListener를 사용하는 방식으로 showDialog를 띄움.

    return Center(
      child: Text(
        weatherState.weather.title,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
