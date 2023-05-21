import 'dart:ui';

import 'package:flutter/material.dart';

SettingConfigure globalSetting = SettingConfigure();

enum DisplayStyle {
  time,
  datetime,
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
    this.isTimeShowBorder = true,
    this.timeBorderRadiusValue = 8,
    this.displayStyle = DisplayStyle.time,
    this.timeFontSizeScale = 1.5,
    this.fontFamily = NumberFontFamily.jetBrainsMono,
    this.sharedScreenSize,
    this.textColorsPaintIndex = 0,
});

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

class SettingManager {

  // 将用户设置加载到内存中
  syncToGlobalSetting() async {

  }

}