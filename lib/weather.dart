import 'dart:convert';

import 'package:http/http.dart' as http;

class Weather {
  Weather(this.description, this.icon, this.id, this.main);

  factory Weather.fromJsonMap(Map<String, dynamic> map) {
    return Weather(
        map['description'] ?? '',
        map['icon'] ?? '',
        map['id'] ?? '',
        map['main'] ?? '');
  }

  final String description;
  final String icon;
  final int id;
  final String main;
}

Future<List<Weather>> fetchOpenWeatherApi(String city, String apikey) async {
  var url = Uri.https(
    "api.openweathermap.org",
    "/data/2.5/forecast",
    {
      "q": city,
      "appid": apikey,
      "lang": "zh_cn"
    }
  );
  List<Weather> list = [];
  try {
    var response = await http.get(url).timeout(Duration(seconds: 15));
    var json = jsonDecode(response.body);
    if (json is Map<String, dynamic> && json['list'] is List) {
      for (Map<String, dynamic> m in (json['list'] as List)) {
        if (m['weather'] is! List) {
          continue;
        }
        for (Map<String, dynamic> w in (m['weather'] as List)) {
          list.add(Weather.fromJsonMap(w));
        }
      }
    }
  } catch(e) {
    print(e);
  }
  return list;
}

void main () async {
  var r = await fetchOpenWeatherApi("shanghai", "");
  print(r);
}