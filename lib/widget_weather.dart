import 'dart:async';
import 'package:flutter/material.dart';
import 'package:funny_time/icons.dart';
import 'config.dart';
import 'widget_helper.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key, this.timerPeriodicCallback, this.weatherStyle = 0});

  final VoidCallback? timerPeriodicCallback;
  final int weatherStyle;

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {

  late final Timer timer;
  late final Timer timerUpdateWeather;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (widget.timerPeriodicCallback != null) {
        widget.timerPeriodicCallback!();
      }
    });
    timerUpdateWeather = Timer.periodic(const Duration(minutes: 1), (timer) {
      SettingManager.flushWeatherInfo();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    timerUpdateWeather.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _styleTempWidgets(),
        )
    );
    if (widget.weatherStyle > 1) {
      final small = Theme.of(context).textTheme.bodySmall;
      return IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            body,
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(child: const Divider(color: Colors.white70, indent: 8, endIndent: 8)),
                Icon(globalSetting.batteryIconData, size: 12 * globalSetting.timeFontSizeScale,),
                Text("${globalSetting.batteryLevel}%", style: small?.copyWith(fontSize: small!.fontSize! * globalSetting.timeFontSizeScale),),
              ],
            ),
            ..._styleTimeWidgets()
          ],
        ),
      );
    }
    return body;
  }

  List<Widget> _styleTimeWidgets() {
    final datetime = DateTime.now();
    final textTheme = Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12 * globalSetting.timeFontSizeScale);
    switch (widget.weatherStyle) {
      case 2:
        return [
          TextUseSetting("${globalSetting.weatherInfo.weather.description}", style: textTheme,),
          TextUseSetting("${formatNumber(datetime.hour)}:${formatNumber(datetime.minute)}", style: textTheme,),
        ];
      case 3:
        return [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(weatherIconDataMap[globalSetting.weatherInfo.weather.icon] ?? WeatherIcons.unknown, size: 14 * globalSetting.timeFontSizeScale,),
              TextUseSetting("${globalSetting.weatherInfo.weather.description}", style: textTheme,),
              TextUseSetting("${formatNumber(datetime.hour)}:${formatNumber(datetime.minute)}", style: textTheme,),
            ],
          )
        ];
      default:
        return [];
    }
  }

  List<Widget> _styleTempWidgets() {
    final bigTextTheme = Theme.of(context).textTheme.displayLarge;
    final textTheme = Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12 * globalSetting.timeFontSizeScale);
    switch (widget.weatherStyle) {
      case 0:
        return [
          TextUseSetting("${globalSetting.weatherInfo.temp.tempRound}℃", style: bigTextTheme,)
        ];
      default:
        return [
          TextUseSetting("${globalSetting.weatherInfo.temp.tempRound}", style: bigTextTheme,),
          TextUseSetting("℃"),
          SizedBox(
            width: 12,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('湿度  ', style: textTheme,),
                    TextUseSetting("${globalSetting.weatherInfo.temp.humidityInt}%")
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon(globalSetting.weatherIconDataMap[globalSetting.weatherInfo.weather.icon] ?? WeatherIcons.unknown),
                    Text('体感  ', style: textTheme,),
                    TextUseSetting("${globalSetting.weatherInfo.temp.feelsLikeInt}℃")
                  ],
                )
              ],
            ),
          ),
        ];
    }
  }

}
