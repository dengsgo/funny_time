import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

const double positionPaddingHeight = 72;

final SettingConfigure globalSetting = SettingConfigure();

enum DisplayStyle {
  time,
  datetime,
  timeBlock,
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
    this.displayStyle = DisplayStyle.time,
    this.timeFontSizeScale = 1.2,
    this.fontFamily = NumberFontFamily.jetBrainsMono,
    this.sharedScreenSize,
    this.textColorsPaintIndex = 3,
    double appScreenBrightnessValue = -1,
}) : _appScreenBrightnessValue = appScreenBrightnessValue;

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

  // 星期文字对应表
  Map<int, String> get weekdayMapping => {
    1: "星期一",
    2: "星期二",
    3: "星期三",
    4: "星期四",
    5: "星期五",
    6: "星期六",
    7: "星期日",
  };

  // 小时文字对应表
  Map<int, String> get hourMapping => {
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

  // 渐变颜色表
  List<List<Color>> get paintLinearColorsMap => [
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
  ];

  Paint? timeTextPaint(int index) {
    if (globalSetting.textColorsPaintIndex == 0
        || index >= globalSetting.paintLinearColorsMap.length) {
      return null;
    }
    return Paint()..shader = LinearGradient(
        colors: globalSetting.paintLinearColorsMap[index]
    ).createShader(Rect.fromLTRB(
      0, 0,
      globalSetting.sharedScreenSize?.width??400,
      globalSetting.sharedScreenSize?.height??0,));
  }
}

enum SettingName {
  openWeatherApikey,
  ;
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
    globalSetting.localStore = await SharedPreferences.getInstance();
    callback();
  }

  static void addMetricsChangeCallback(VoidCallback callback) {
    _metricsChangeCallback = callback;
  }

  static void triggerMetricsChangeCallback() {
    if (_metricsChangeCallback != null) {
      _metricsChangeCallback!();
    }
  }

  static T? getConfig<T extends Object>(SettingName key) {
    var value = globalSetting.localStore.get(key.name);
    if (value == null) {
      return null;
    }
    return value as T;
  }
  static void setConfig<T extends Object>(SettingName key, T value) {
    switch (T) {
      case int:
        globalSetting.localStore.setInt(key.name, value as int);
      case bool:
        globalSetting.localStore.setBool(key.name, value as bool);
      case double:
        globalSetting.localStore.setDouble(key.name, value as double);
      case String:
        globalSetting.localStore.setString(key.name, value as String);
      case List:
        globalSetting.localStore.setStringList(key.name, value as List<String>);
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