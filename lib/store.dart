import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

enum SettingName {
  weatherInfo,
  weatherLastUpdateTime,
  weatherSet,
  autoSet,
  autoUUID,
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

class AutoSet {
  AutoSet({this.lowBrightnessTimeSlot, this.lowBrightnessValue = 10});

  List<int>? lowBrightnessTimeSlot; // 低亮度时间段
  int lowBrightnessValue;

  factory AutoSet.fromJsonMap(Map<String, dynamic> map) {
    return AutoSet(
      lowBrightnessTimeSlot: List<int>.from(map['lowBrightnessTimeSlot']),
      lowBrightnessValue: map['lowBrightnessValue'] as int,
    );
  }

  factory AutoSet.fromJsonStr(String? str) {
    try {
      var map = jsonDecode(str!);
      return AutoSet.fromJsonMap(map);
    } catch (e) {
      print("AutoSet.fromJsonStr jsonDecode fail {$e}");
    }
    return AutoSet();
  }

  factory AutoSet.loadLocal() {
    var store = getConfig<String>(SettingName.autoSet);
    print(store);
    return AutoSet.fromJsonStr(store);
  }

  void storeLocal() {
    print(toString());
    setConfig<String>(SettingName.autoSet, toString());
  }

  Map toMap() {
    return {
      "lowBrightnessTimeSlot": lowBrightnessTimeSlot,
      "lowBrightnessValue": lowBrightnessValue,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

class AutoUUIDSet {
  AutoUUIDSet(this.uuid);

  String uuid = "";

  factory AutoUUIDSet.loadLocal() {
    var store = getConfig<String>(SettingName.autoUUID);
    print(store);
    var set = AutoUUIDSet(store??"");
    if (store == null) {
      set.storeLocal();
    }
    return set;
  }

  void storeLocal() {
    uuid = genUUID();
    print("setUUID $uuid");
    setConfig<String>(SettingName.autoUUID, uuid!);
  }

  String genUUID() {
    List<int> bytes = [];
    for (int i = 0; i < 24; i++) {
      int index = Random.secure().nextInt(36);
      bytes.add(index < 10 ? index + 48 : index + 87); // 0 - 9, a - z
    }
    return String.fromCharCodes(bytes);
  }
}