import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:funny_time/icons.dart';
import 'package:funny_time/store.dart';
import 'package:funny_time/weather.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

const double positionPaddingHeight = 72;

final SettingConfigure globalSetting = SettingConfigure();

enum DisplayStyle {
  time,
  datetime,
  timeBlock,
  timeBlockWeather,
  timeBlockTemp,
  timeBlockWeaTemp,
  weatherBigTemp,
  weatherBigTemp1,
  weatherBigTemp1Time,
  weatherBigTemp1Time1,
}

enum NumberFontFamily {
  jetBrainsMono("JetBrainsMono"),
  digital7("digital7"),
  arturito("Arturito"),
  babyground("babyground"),
  boisu("Boisu"),
  zystoo("zystoo"),
  compagnon("Compagnon"),
  cute("Cute"),
  facon("Facon"),
  fulbo("Fulbo"),
  gap("Gap"),
  kalmansk("Kalmansk"),
  pixopedia("pixopedia"),
  quirky("Quirky"),
  versa("Versa"),
  ;
  const NumberFontFamily(this.name);
  final String name;
}

class SettingConfigure {
  SettingConfigure({
    this.isViewMotionOpen = true,
    this.stepRandomMaxValue = 6,
    this.timeSecondColor = Colors.redAccent,
    this.isTimeShowBorder = false,
    this.timeBorderRadiusValue = 8,
    this.displayStyle = DisplayStyle.weatherBigTemp1Time1,
    this.timeFontSizeScale = 1.2,
    this.fontFamily = NumberFontFamily.jetBrainsMono,
    this.sharedScreenSize,
    this.textColorsPaintIndex = 3,
    double appScreenBrightnessValue = -1,
    this.weatherInfo = const WeatherInfo(0, Temperature(0, 0, 0), Weather('', '', 0, '')),
}) : _appScreenBrightnessValue = appScreenBrightnessValue,
  weatherLastUpdateTime = WeatherLastUpdateTime(),
        weatherSet = WeatherSet();

  // 当前的样式
  DisplayStyle displayStyle;

  // 时间组件运动设置
  bool isViewMotionOpen;
  int stepRandomMaxValue;

  // 时间显示设置
  NumberFontFamily fontFamily;
  Color? timeSecondColor;
  bool isTimeShowBorder;
  double timeBorderRadiusValue;
  double timeFontSizeScale;
  int textColorsPaintIndex;

  // 天气显示设置
  WeatherInfo weatherInfo;
  WeatherSet weatherSet;
  WeatherLastUpdateTime weatherLastUpdateTime;
  int weatherActiveFlushApiCount = 0;

  // 屏幕尺寸共享
  Size? sharedScreenSize;
  Size? sharedTimeViewSize;

  // plugins
  late SharedPreferences localStore;
  double _appScreenBrightnessValue;

  // 保存亮度值，并尝试设置app亮度
  set appScreenBrightnessValue (v) {
    if (v >= 1 || v <= 0.0) {
      return;
    }
    _appScreenBrightnessValue = v;
    setBrightness(v);
  }

  // 获取亮度值
  get appScreenBrightnessValue => _appScreenBrightnessValue;

  Paint? timeTextPaint(int index) {
    if (globalSetting.textColorsPaintIndex == 0
        || index >= paintLinearColorsMap.length) {
      return null;
    }
    return Paint()..shader = LinearGradient(
        colors: paintLinearColorsMap[index]
    ).createShader(Rect.fromLTRB(
      0, 0,
      globalSetting.sharedScreenSize?.width??400,
      globalSetting.sharedScreenSize?.height??0,));
  }
}

class SettingManager {

  static VoidCallback? _metricsChangeCallback;

  // 将用户设置加载到内存中
  static Future<void> init(VoidCallback callback) async {
    // TODO load local
    // 获取系统亮度
    if (!kIsWeb) {
      globalSetting.appScreenBrightnessValue = await currentBrightness;
    }
    // Obtain shared preferences.
    localStore = await SharedPreferences.getInstance();
    callback();
    // load weather
    globalSetting.weatherInfo = WeatherInfo.loadLocal();
    globalSetting.weatherSet = WeatherSet.loadLocal();
    globalSetting.weatherLastUpdateTime = WeatherLastUpdateTime.loadLocal();
    print(globalSetting.weatherInfo);
    if (globalSetting.weatherInfo.weather.icon == '') {
      await flushWeatherInfo(false);
    }
    await flushWeatherInfo();
  }

  // 刷新天气信息
  static flushWeatherInfo([bool useCache = true]) async {
    print("flushWeatherInfo in");
    if (globalSetting.weatherSet.apikey == null || globalSetting.weatherSet.city == null) {
      globalSetting.weatherInfo = const WeatherInfo(0, Temperature(0, 0, 0), Weather('', 'fail', 0, ''));
      return ;
    }
    print("flushWeatherInfo exec");
    // half an hour update once at most
    if (!useCache || DateTime.now().millisecondsSinceEpoch - globalSetting.weatherLastUpdateTime.value > 1000 * 60 * 30) {
      globalSetting.weatherLastUpdateTime.value = DateTime.now().millisecondsSinceEpoch;
      final weatherList = await fetchOpenWeatherApi(globalSetting.weatherSet.city!, globalSetting.weatherSet.apikey!);
      print("weatherList");
      print(weatherList);
      if (weatherList.length > 0) {
        globalSetting.weatherInfo = getCurrentWeatherInfo(weatherList);
        globalSetting.weatherInfo.storeLocal();
        globalSetting.weatherLastUpdateTime.storeLocal();
        print("save");
        print(globalSetting.weatherInfo.toString());
        globalSetting.weatherActiveFlushApiCount++;
      }
    }
  }

  static void addMetricsChangeCallback(VoidCallback callback) {
    _metricsChangeCallback = callback;
  }

  static void triggerMetricsChangeCallback() {
    if (_metricsChangeCallback != null) {
      _metricsChangeCallback!();
    }
  }

}

Future<double> get currentBrightness async {
  try {
    return await ScreenBrightness().current;
  } catch (e) {
    print("currentBrightness $e");
  }
  return Future(() => -1);
}

Future<void> setBrightness(double brightness) async {
  try {
    await ScreenBrightness().setScreenBrightness(brightness);
  } catch (e) {
    print(e);
  }
}

void wakeLockEnable() {
  try {
    if (!kIsWeb) {
      Wakelock.enable();
    }
  } catch(e) {
    print(e);
  }
}

void wakeLockDisable() {
  try {
    if (!kIsWeb) {
      Wakelock.disable();
    }
  } catch(e) {
    print(e);
  }
}

// weather icons

// global

// 星期文字对应表
final Map<int, String> weekdayMapping = {
  1: "星期一",
  2: "星期二",
  3: "星期三",
  4: "星期四",
  5: "星期五",
  6: "星期六",
  7: "星期日",
};

// 小时文字对应表
const Map<int, String> hourMapping = {
  23: "深夜",
  0: "深夜",
  1: "深夜",
  2: "深夜",
  3: "深夜",
  4: "深夜",
  5: "清晨",
  6: "清晨",
  7: "早上",
  8: "早上",
  9: "上午",
  10: "上午",
  11: "上午",
  12: "中午",
  13: "午后",
  14: "下午",
  15: "下午",
  16: "下午",
  17: "傍晚",
  18: "晚上",
  19: "晚上",
  20: "晚上",
  21: "入夜",
  22: "入夜",
};

// 获取openweather天气图标对应表
const Map<String, IconData> weatherIconDataMap = {
  "01d": WeatherIcons.sunny,
  "02d": WeatherIcons.cloudy,
  "03d": WeatherIcons.overcast,
  "04d": WeatherIcons.overcast,
  "09d": WeatherIcons.showerRain,
  "10d": WeatherIcons.rain,
  "11d": WeatherIcons.thunderstorm,
  "13d": WeatherIcons.snow,
  "50d": WeatherIcons.fog,

  "01n": WeatherIcons.sunny,
  "02n": WeatherIcons.cloudy,
  "03n": WeatherIcons.overcast,
  "04n": WeatherIcons.overcast,
  "09n": WeatherIcons.showerRain,
  "10n": WeatherIcons.rain,
  "11n": WeatherIcons.thunderstorm,
  "13n": WeatherIcons.snow,
  "50n": WeatherIcons.fog,
};

// 渐变颜色表
const List<List<Color>> paintLinearColorsMap = [
  [], // 0 default = null
  [
    Colors.blue,
    Colors.green,
    Colors.deepPurpleAccent,
    Colors.purpleAccent
  ],
  [
    Colors.deepPurpleAccent,
    Colors.purpleAccent,
    Colors.blue,
    Colors.green,
  ],
  [
    Colors.deepPurpleAccent,
    Colors.blue,
    Colors.lightBlue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
  ],
  [
    Colors.orange,
    Colors.redAccent,
    Colors.red,
    Colors.lightBlue,
    Colors.deepPurpleAccent,
    Colors.orange,
    Colors.green,
  ],
  [
    Colors.red,
    Colors.orange,
    Colors.lightBlue,
    Colors.green,
  ],
  [
    Colors.green,
    Colors.redAccent,
    Colors.cyan,
    Colors.orange,
  ],
  [
    Colors.redAccent,
    Colors.deepPurpleAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
  ],
  [
    Colors.yellow,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.cyan,
  ],
];

