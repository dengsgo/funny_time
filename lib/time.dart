import 'dart:async';
import 'dart:math';
import 'dart:ui' show Gradient;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Gradient;
import 'package:funny_time/config.dart';
import 'package:funny_time/minix.dart';
import 'package:funny_time/setting.dart';
import 'package:funny_time/widget_time.dart';
import 'package:funny_time/widget_timeblock.dart';
import 'package:funny_time/widget_weather.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<StatefulWidget> createState() => _TimePageState();

}

class _TimePageState extends State<TimePage> {

  bool _showBottomNavigationBar = false;

  tapTimeViewHandler() {
    setState(() {
      _showBottomNavigationBar = !_showBottomNavigationBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: OrientationBuilder(
        builder: (context, orientation) {
          // print("OrientationBuilder $orientation ${MediaQuery.sizeOf(context)}");
          globalSetting.sharedScreenSize = MediaQuery.sizeOf(context);
          return PositionView(tapCallback: tapTimeViewHandler,);
        },
      ),
      bottomNavigationBar: _showBottomNavigationBar ? BottomAppBar(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            IconButton(onPressed: (){
              int index = globalSetting.displayStyle.index;
              if (++index >= DisplayStyle.values.length) {
                index = 0;
              }
              globalSetting.displayStyle = DisplayStyle.values[index];
              setState(() {});
            }, icon: const Icon(Icons.style_outlined), tooltip: "样式",),
            IconButton(onPressed: (){
              globalSetting.isTimeShowBorder = !globalSetting.isTimeShowBorder;
              setState(() {});
            }, icon: Icon(Icons.border_all), tooltip: "显隐边框",),
            IconButton(onPressed: () {
              int index = globalSetting.fontFamily.index;
              if (++index >= NumberFontFamily.values.length) {
                index = 0;
              }
              globalSetting.fontFamily = NumberFontFamily.values[index];
              print(globalSetting.fontFamily);
              setState(() {});
            }, icon: Icon(Icons.font_download_outlined), tooltip: "换字体",),
            IconButton(onPressed: (){
              int index = globalSetting.textColorsPaintIndex;
              if (++index >= paintLinearColorsMap.length) {
                index = 0;
              }
              globalSetting.textColorsPaintIndex = index;
              setState(() {});
            }, icon: Icon(Icons.color_lens_outlined), tooltip: "换渐变色",),
            IconButton(onPressed: (){
              globalSetting.appScreenBrightnessValue += 0.05;
              setState(() {});
            }, icon: Icon(Icons.wb_twilight_rounded), tooltip: "增亮",),
            IconButton(onPressed: (){
              globalSetting.appScreenBrightnessValue -= 0.05;
              setState(() {});
            }, icon: Icon(Icons.nightlight_outlined), tooltip: "减亮",),
            IconButton(onPressed: (){
              globalSetting.timeFontSizeScale += 0.1;
              setState(() {});
            }, icon: Icon(Icons.plus_one), tooltip: "增大显示",),
            IconButton(onPressed: (){
              globalSetting.timeFontSizeScale -= 0.1;
              setState(() {});
            }, icon: Icon(Icons.exposure_minus_1), tooltip: "减小显示",),
          ],
        ),
      ) : null,
      floatingActionButton: _showBottomNavigationBar ? FloatingActionButton.extended(
        onPressed: _showHelp,
        tooltip: '设置',
        icon: const Icon(Icons.settings),
        label: Text("设置"),
      ) : null,
    );
  }

  _showHelp() {
    Navigator.of(context).pushNamed(SettingPage.routeName);
  }

}

class PositionView extends StatefulWidget {
  const PositionView({super.key, required this.tapCallback});

  final GestureTapCallback tapCallback;

  @override
  State<StatefulWidget> createState() => _PositionViewState();

}

class _PositionViewState extends PositionViewState<PositionView> {

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StatefulWidget view;
    switch (globalSetting.displayStyle) {
      case DisplayStyle.time:
        view = TimeView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback);
      case DisplayStyle.datetime:
        view = DateTimeView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback);
      case DisplayStyle.timeBlock:
        view = TimeBlockView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback);
      case DisplayStyle.timeBlockWeather:
        view = TimeBlockView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback, weatherStyle: 1,);
      case DisplayStyle.timeBlockTemp:
        view = TimeBlockView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback, weatherStyle: 2,);
      case DisplayStyle.timeBlockWeaTemp:
        view = TimeBlockView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback, weatherStyle: 3,);
      case DisplayStyle.weatherBigTemp:
        view = WeatherView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback);
      case DisplayStyle.weatherBigTemp1:
        view = WeatherView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback, weatherStyle: 1,);
      case DisplayStyle.weatherBigTemp1Time:
        view = WeatherView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback, weatherStyle: 2,);
      case DisplayStyle.weatherBigTemp1Time1:
        view = WeatherView(key: timeViewKey, timerPeriodicCallback: timerPeriodicCallback, weatherStyle: 3,);
    }
    return Stack(
      children: [
        Container(
          margin: positionMargin,
          decoration: BoxDecoration(
            border: globalSetting.isTimeShowBorder ? Border.all(
              width: 0,
              color: Colors.white,
            ) : null,
            borderRadius: BorderRadius.circular(globalSetting.timeBorderRadiusValue),
          ),
          child: InkWell(
            onTap: widget.tapCallback,
            child: view,
          ),
        )
      ],
    );
  }

}


