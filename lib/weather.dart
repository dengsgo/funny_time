import 'dart:convert';

import 'package:funny_time/config.dart';
import 'package:funny_time/icons.dart';
import 'package:funny_time/store.dart';
import 'package:http/http.dart' as http;

class Weather {
  const Weather(this.description, this.icon, this.id, this.main);

  factory Weather.fromJsonMap(Map<String, dynamic> map) {
    return Weather(
        map['description'] ?? '',
        map['icon'] ?? '',
        map['id'] ?? 0,
        map['main'] ?? '');
  }

  final String description;
  final String icon;
  final int id;
  final String main;

  @override
  String toString() {
    return '{"description": "$description", "icon": "$icon", "id": $id, "main": "$main"}';
  }
}

class Temperature {
  const Temperature(this.temp, this.feelsLike, this.humidity);

  factory Temperature.fromJsonMap(Map<String, dynamic> map) {
    return Temperature(
        map['temp'] ?? 0.0,
        map['feels_like'] ?? 0.0,
        map['humidity'] ?? 0.0);
  }

  final double temp;
  final double feelsLike;
  final num humidity;

  get humidityInt => humidity.toInt();
  get feelsLikeInt => feelsLike.toInt();
  get tempInt => temp.toInt();
  get tempRound => temp.toStringAsFixed(1);

  @override
  String toString() {
    return '{"temp": $temp, "feels_like": $feelsLike, "humidity": $humidity}';
  }
}

class WeatherInfo {
  const WeatherInfo(this.dt, this.temp, this.weather);

  factory WeatherInfo.fromJsonMap(Map<String, dynamic> map) {
    return WeatherInfo(
        map['dt'] ?? 0,
        Temperature.fromJsonMap(map['main'] ?? {}),
        Weather.fromJsonMap(map['weather']?[0] ?? {}));
  }

  factory WeatherInfo.fromEmpty() {
    return WeatherInfo.fromJsonMap(<String, dynamic>{});
  }

  factory WeatherInfo.fromJsonStr(String? str) {
    if (str == null) {
      return WeatherInfo.fromEmpty();
    }
    try {
      return WeatherInfo.fromJsonMap(jsonDecode(str));
    } catch(e) {
      print(e);
    }
    return WeatherInfo.fromEmpty();
  }

  final int dt;
  final Temperature temp;
  final Weather weather;

  @override
  String toString() {
    return '{"dt":$dt, "main": $temp, "weather": [$weather]}';
  }

  factory WeatherInfo.loadLocal() {
    var weatherStrInfo = getConfig<String>(SettingName.weatherInfo);
    print(weatherStrInfo);
    return WeatherInfo.fromJsonStr(weatherStrInfo);
  }

  void storeLocal() {
    setConfig<String>(SettingName.weatherInfo, toString());
  }
}

Future<List<WeatherInfo>> fetchOpenWeatherApi(String city, String apikey) async {
  var url = Uri.https(
    "api.openweathermap.org",
    "/data/2.5/forecast",
    {
      "q": city,
      "appid": apikey,
      "lang": "zh_cn",
      "units": "metric",
    }
  );
  List<WeatherInfo> list = [];
  try {
    var response = await http.get(
        url, headers: {"User-Agent": userAgent},
    ).timeout(Duration(seconds: 15));
    var json = jsonDecode(response.body);
    if (json is Map<String, dynamic> && json['list'] is List) {
      for (Map<String, dynamic> m in (json['list'] as List)) {
        if (m['dt'] is! int) {
          continue;
        }
        if (m['weather'] is! List || m['main'] is! Map<String, dynamic>) {
          continue;
        }
        list.add(WeatherInfo.fromJsonMap(m));
      }
    }
  } catch(e) {
    print(e);
  }
  return list;
}

WeatherInfo getCurrentWeatherInfo(List<WeatherInfo> list) {
  var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  for (WeatherInfo info in list) {
    if (info.dt >= now) {
      return info;
    }
  }
  return list.last;
}

void main () async {
  var r = await fetchOpenWeatherApi("shanghai", "");
  print(r);
  print(getCurrentWeatherInfo(r));
}