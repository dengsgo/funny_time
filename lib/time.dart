import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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
      appBar: MediaQuery.orientationOf(context) == Orientation.portrait ?
      AppBar(backgroundColor: Colors.black,) : null,
      body: PositionView(tapCallback: tapTimeViewHandler,),
      bottomNavigationBar: _showBottomNavigationBar ? BottomAppBar(
        child: Row(
          children: [
            IconButton(onPressed: (){
              globalSetting.displayStyle = DisplayStyle.datetime;
            }, icon: const Icon(Icons.refresh)),
            IconButton(onPressed: (){
              globalSetting.displayStyle = DisplayStyle.time;
            }, icon: Icon(Icons.settings)),
            IconButton(onPressed: (){
              globalSetting.isTimeShowBorder = !globalSetting.isTimeShowBorder;
            }, icon: Icon(Icons.light)),
          ],
        ),
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
    final DateTime datetime = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TimeStyleRender(datetime: datetime,),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${datetime.month}-${datetime.day} / ${datetime.year}"),
              Text("    "),
              Text(globalSetting.weekdayMapping[datetime.weekday]??""),
            ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _NumberComponent(number: datetime.hour),
          Text(":" ,style: Theme.of(context).textTheme.displayLarge,),
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
    return Text(show,
      style: Theme.of(context).textTheme.displayLarge,);
  }

}

class _SecondComponent extends StatelessWidget {
  const _SecondComponent({super.key,
    required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final String show = number > 9 ? "$number" : "0$number";
    return Text(show,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(color: globalSetting.timeSecondColor),);
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
