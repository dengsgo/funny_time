import 'package:flutter/material.dart';
import 'package:funny_time/config.dart';

class TextUseSetting extends StatelessWidget {
  const TextUseSetting(this.data, {super.key, this.style, this.color});

  final String? data;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var _style = style;
    _style ??= Theme.of(context).textTheme.bodyMedium;
    var custemStyle = _style?.copyWith(
      fontFamily: globalSetting.fontFamily.name,
      fontSize: (_style?.fontSize??1) * globalSetting.timeFontSizeScale,
    );
    if (color == null) {
      custemStyle = custemStyle?.copyWith(
        foreground: globalSetting.timeTextPaint(globalSetting.textColorsPaintIndex),
      );
    } else {
      custemStyle = custemStyle?.copyWith(
        color: color,
      );
    }
    return Text(
      data??"",
      style: custemStyle,
    );
  }

}

String formatNumber(int number) {
  return number > 9 ? "$number" : "0$number";
}
