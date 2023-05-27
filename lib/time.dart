import 'dart:async';
import 'dart:math';
import 'dart:ui' show Gradient;

import 'package:flutter/material.dart' hide Gradient;
import 'package:funny_time/setting.dart';
import 'package:funny_time/minix.dart';

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
      body: PositionView(tapCallback: tapTimeViewHandler,),
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
              if (++index >= globalSetting.paintLinearColorsMap.length) {
                index = 0;
              }
              globalSetting.textColorsPaintIndex = index;
              setState(() {});
            }, icon: Icon(Icons.color_lens_outlined), tooltip: "换渐变色",),
            IconButton(onPressed: (){
              globalSetting.appScreenBrightnessValue += 0.1;
              setState(() {});
            }, icon: Icon(Icons.wb_twilight_rounded), tooltip: "增亮",),
            IconButton(onPressed: (){
              globalSetting.appScreenBrightnessValue -= 0.1;
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
      floatingActionButton: _showBottomNavigationBar ? FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ) : null,
    );
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

class DateTimeView extends StatefulWidget {
  const DateTimeView({super.key, this.timerPeriodicCallback});

  final VoidCallback? timerPeriodicCallback;

  @override
  State<StatefulWidget> createState() => _DateTimeViewState();

}

class _DateTimeViewState extends State<DateTimeView> {

  late final Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1), (timer) {
      (widget.timerPeriodicCallback ?? (){})();
      setState(() {});
    }
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    final DateTime datetime = DateTime.now();
    return IntrinsicWidth(
      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TimeStyleRender(datetime: datetime,),
          Container(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${datetime.month}-${datetime.day} / ${datetime.year}", style: style?.copyWith(
                    fontFamily: globalSetting.fontFamily.name
                ),),
                Expanded(child: Text("")),
                Text(globalSetting.weekdayMapping[datetime.weekday]??""),
              ],
            ),
          )
        ],
      ),
    );
  }

}

class TimeView extends StatefulWidget {
  const TimeView({super.key, this.timerPeriodicCallback});

  final VoidCallback? timerPeriodicCallback;

  @override
  State<StatefulWidget> createState() => _TimeViewState();

}

class _TimeViewState extends State<TimeView> {

  late final Timer timer;
  late final Widget colon = Text(":" ,style: Theme.of(context).textTheme.displayLarge,);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1), (timer) {
          (widget.timerPeriodicCallback ?? (){})();
          setState(() {});
        }
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime datetime = DateTime.now();
    return _TimeStyleRender(datetime: datetime);
  }

}

class _TimeStyleRender extends StatelessWidget {
  const _TimeStyleRender({required this.datetime});

  final DateTime datetime;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.displayLarge;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        textBaseline: TextBaseline.alphabetic,
        children: [
          _NumberComponent(number: datetime.hour),
          Text(":" ,style: style?.copyWith(
            fontFamily: globalSetting.fontFamily.name,
            fontSize: (style?.fontSize??1) * globalSetting.timeFontSizeScale,
            foreground: globalSetting.timeTextPaint(globalSetting.textColorsPaintIndex),
          ),),
          _NumberComponent(number: datetime.minute),
          Container(width: 8, height: 0,),
          _SecondIncludeTextComponent(
            number: datetime.second,
            hour: datetime.hour,
            color: Colors.redAccent,),
        ],
      ),
    );
  }
}

class _NumberComponent extends StatelessWidget {
  const _NumberComponent({super.key,
    required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final String show = number > 9 ? "$number" : "0$number";
    final style = Theme.of(context).textTheme.displayLarge;
    return Text(show,
      style: style?.copyWith(
        fontFamily: globalSetting.fontFamily.name,
        fontSize: (style?.fontSize??1) * globalSetting.timeFontSizeScale,
          foreground: globalSetting.timeTextPaint(globalSetting.textColorsPaintIndex),
      ),);
  }

}



class _SecondComponent extends StatelessWidget {
  const _SecondComponent({super.key,
    required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final String show = number > 9 ? "$number" : "0$number";
    final style = Theme.of(context).textTheme.headlineLarge;
    return Text(show,
      style: style?.copyWith(
        color: globalSetting.timeSecondColor,
        fontFamily: globalSetting.fontFamily.name,
        fontSize: (style?.fontSize??1) * globalSetting.timeFontSizeScale,
      ),);
  }

}

class _SecondIncludeTextComponent extends StatelessWidget {
  const _SecondIncludeTextComponent({super.key,
    required this.number,
    required this.hour,
    this.color});

  final int number;
  final Color? color;
  final int hour;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(globalSetting.hourMapping[hour]??""),
        _SecondComponent(number: number)
      ],
    );
  }

}
