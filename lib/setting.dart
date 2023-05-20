import 'dart:ui';

import 'package:flutter/material.dart';

SettingConfigure globalSetting = SettingConfigure();

enum DisplayStyle {
  time,
  datetime,
}

class SettingConfigure {
  SettingConfigure({
    this.isViewMotionOpen = true,
    this.stepRandomMaxValue = 6,
    this.timeSecondColor = Colors.redAccent,
    this.isTimeShowBorder = true,
    this.timeBorderRadiusValue = 8,
    this.displayStyle = DisplayStyle.time,
});

  // 当前的样式
  DisplayStyle displayStyle;

  // 时间组件运动设置
  bool isViewMotionOpen;
  int stepRandomMaxValue;

  // 时间显示设置
  Color? timeSecondColor;
  bool isTimeShowBorder;
  double timeBorderRadiusValue;

  // 星期文字对应表
  Map<int, String> weekdayMapping = {
    1: "星期一",
    2: "星期二",
    3: "星期三",
    4: "星期四",
    5: "星期五",
    6: "星期六",
    7: "星期日",
  };

  // 小时文字对应表
  Map<int, String> hourMapping = {
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
}

class SettingManager {

  // 将用户设置加载到内存中
  syncToGlobalSetting() async {

  }

}