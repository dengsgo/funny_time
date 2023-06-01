import 'package:flutter/material.dart';

const _weatherIconsFontFam = 'qweather-icons';

class WeatherIcons {
  static const IconData sunny = IconData(0xf101, fontFamily: _weatherIconsFontFam);
  static const IconData cloudy = IconData(0xf102, fontFamily: _weatherIconsFontFam);
  static const IconData overcast = IconData(0xf105, fontFamily: _weatherIconsFontFam, );
  static const IconData showerRain = IconData(0xf10a, fontFamily: _weatherIconsFontFam); // 阵雨
  static const IconData rain = IconData(0xf110, fontFamily: _weatherIconsFontFam);// 雨
  static const IconData thunderstorm = IconData(0xf10c, fontFamily: _weatherIconsFontFam);// 雷雨
  static const IconData snow = IconData(0xf12d, fontFamily: _weatherIconsFontFam);
  static const IconData fog = IconData(0xf135, fontFamily: _weatherIconsFontFam);
  static const IconData unknown = IconData(0xf146, fontFamily: _weatherIconsFontFam);
  static const IconData hotDay = IconData(0xf1b6, fontFamily: _weatherIconsFontFam);
  static const IconData lowHumidity = IconData(0xf1bd, fontFamily: _weatherIconsFontFam);
}

class WeatherIcon {

}
