import 'dart:async';
import 'package:flutter/material.dart';
import 'package:funny_time/icons.dart';
import 'config.dart';
import 'widget_helper.dart';

class TimeBlockView extends StatefulWidget {
  const TimeBlockView({super.key, this.timerPeriodicCallback, this.weatherStyle = 0});

  final VoidCallback? timerPeriodicCallback;
  final int weatherStyle;

  @override
  State<StatefulWidget> createState() => _TimeBlockViewState();

}

class _TimeBlockViewState extends State<TimeBlockView> {

  late final Timer timer;
  late final Timer timerUpdateWeather;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1), (timer) {
      (widget.timerPeriodicCallback ?? (){})();
      setState(() {});
    }
    );
    timerUpdateWeather = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateWeather();
    }
    );
  }

  _updateWeather() {
    if (widget.weatherStyle == 0) {
      return ;
    }
    SettingManager.flushWeatherInfo();
  }

  @override
  void dispose() {
    print("_TimeBlockViewState dispose");
    timer.cancel();
    timerUpdateWeather?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.displayLarge;
    final styleme = Theme.of(context).textTheme.titleLarge;
    final DateTime datetime = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ..._weatherStyleWidgets(),
          TextUseSetting(formatNumber(datetime.hour), style: style,),
          const SizedBox(
            width: 12,
            height: 0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextUseSetting(formatNumber(datetime.minute), style: styleme,),
              TextUseSetting(formatNumber(datetime.second), style: styleme, color: Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weatherStyle1Widget() {
    return Icon(weatherIconDataMap[globalSetting.weatherInfo.weather.icon] ?? WeatherIcons.unknown,
      size: 40 * globalSetting.timeFontSizeScale, color: Colors.white.withOpacity(0.9),);
  }

  Widget _weatherStyle2Widget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(WeatherIcons.hotDay, size: 12 * globalSetting.timeFontSizeScale,),
            Text("  ${globalSetting.weatherInfo.temp.temp.round()}℃"),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(WeatherIcons.lowHumidity, size: 12 * globalSetting.timeFontSizeScale,),
            Text("  ${globalSetting.weatherInfo.temp.humidity}％"),
          ],
        ),
      ],
    );
  }

  List<Widget> _weatherStyleWidgets() {
    if (widget.weatherStyle == 0) {
      return <Widget>[];
    }
    late final Widget icon;
    if (globalSetting.weatherInfo.weather.icon == "") {
      // 加载中
      icon = const CircularProgressIndicator.adaptive(
        strokeWidth: 2,
      );
    } else if (globalSetting.weatherInfo.weather.icon == "fail") {
      // 加载失败
      icon = Icon(WeatherIcons.unknown,
        size: 40 * globalSetting.timeFontSizeScale, color: Colors.white.withOpacity(0.9),);;
    } else {
      switch (widget.weatherStyle) {
        case 1:
          icon = _weatherStyle1Widget();
          break;
        case 2:
          icon = _weatherStyle2Widget();
          break;
        default:
          icon = Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _weatherStyle1Widget(),
              SizedBox(
                width: 12,
              ),
              _weatherStyle2Widget(),
            ],
          );
      }
    }

    return <Widget>[
      icon,
      Container(
        height: 16 * globalSetting.timeFontSizeScale,
        width: 0,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(
              width: 0.5,
              color: Colors.white54,
            ),
          ),
        ),
      )
    ];
  }

}