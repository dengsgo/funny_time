import 'dart:async';

import 'package:flutter/material.dart';

import 'config.dart';
import 'widget_helper.dart';

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
                Text(weekdayMapping[datetime.weekday]??""),
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
          TextUseSetting(
            "${formatNumber(datetime.hour)}:${formatNumber(datetime.minute)}",
            style: style,
          ),
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
        Text(hourMapping[hour]??""),
        _SecondComponent(number: number)
      ],
    );
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