import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum SettingName {
  weatherInfo,
  weatherLastUpdateTime,
  weatherSet,
  ;
}

late SharedPreferences localStore;

T? getConfig<T extends Object>(SettingName key) {
  var value = localStore.get(key.name);
  if (value == null) {
    return null;
  }
  return value as T;
}

void setConfig<T extends Object>(SettingName key, T value) {
  switch (T) {
    case int:
      localStore.setInt(key.name, value as int);
    case bool:
      localStore.setBool(key.name, value as bool);
    case double:
      localStore.setDouble(key.name, value as double);
    case String:
      localStore.setString(key.name, value as String);
    case List:
      localStore.setStringList(key.name, value as List<String>);
  }
}

class WeatherSet {

  String? city;
  String? apikey;

  static const String _localKey = "weatherSet";

  WeatherSet({this.city, this.apikey});

  factory WeatherSet.fromJsonMap(Map<String, dynamic> map) {
    return WeatherSet(
        city: map['city'] as String?,
        apikey: map['apikey'] as String?
    );
  }

  factory WeatherSet.fromJsonStr(String? str) {
    if (str == null) {
      return WeatherSet();
    }
    try {
      return WeatherSet.fromJsonMap(jsonDecode(str));
    } catch (e) {
      print("SettingWeatherContent.fromJsonStr jsonDecode fail {$e}");
    }
    return WeatherSet();
  }

  Map toMap() {
    return {
      "city": city,
      "apikey": apikey
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  factory WeatherSet.loadLocal() {
    var store = getConfig<String>(SettingName.weatherSet);
    return WeatherSet.fromJsonStr(store);
  }

  void storeLocal() {
    setConfig<String>(SettingName.weatherSet, toString());
  }
}

class WeatherLastUpdateTime {
  WeatherLastUpdateTime({this.value = 0});
  int value;

  factory WeatherLastUpdateTime.loadLocal() {
    var store = getConfig<int>(SettingName.weatherLastUpdateTime);
    return WeatherLastUpdateTime(value: store ?? 0);
  }

  void storeLocal() {
    setConfig<int>(SettingName.weatherLastUpdateTime, value);
  }
}