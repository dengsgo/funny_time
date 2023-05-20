import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_time/setting.dart';

class PositionViewState<T extends StatefulWidget> extends State<T> {
  final timeViewKey = GlobalKey();
  Size? _timeviewSize;
  late Size _screenSize;
  EdgeInsets positionMargin = EdgeInsets.zero;
  VoidCallback? timerPeriodicCallback;
  bool _xOffsetReverse = false, _yOffsetReverse = false;

  addPostFrameCallback() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("addPostFrameCallback $timeStamp");
      final RenderObject? renderBox = timeViewKey.currentContext?.findRenderObject();
      print("renderBox ${renderBox?.paintBounds.size}");
      _timeviewSize = renderBox?.paintBounds.size;
      _screenSize = MediaQuery.of(context).size;
      print("renderBox ${MediaQuery.of(context).size}");
      _centerWidget();
      _motionWidget();
    });
  }

  _centerWidget() {
    if (_timeviewSize == null) {
      return;
    }
    var widgetSize = _timeviewSize!;
    if (_screenSize.width < widgetSize.width) {
      // 屏幕比组件要窄
      print("_screenSize.width < widgetSize.width");
      return;
    }
    if (_screenSize.height < widgetSize.height) {
      // 屏幕比组件要短
      print("_screenSize.height < widgetSize.height");
      return;
    }
    double left = (_screenSize.width - widgetSize.width) / 2;
    double top = (_screenSize.height - widgetSize.height - 56) / 2;
    positionMargin = EdgeInsets.only(left: left, top: top);
    // 随机 x y 方向
    _xOffsetReverse = Random.secure().nextBool();
    _yOffsetReverse = Random.secure().nextBool();
    setState(() {});
  }

  _motionWidget() {
    if (!globalSetting.isViewMotionOpen) {
      return;
    }
    if (_timeviewSize == null) {
      return;
    }
    var widgetSize = _timeviewSize!;
    if (_screenSize.width < widgetSize.width) {
      // 屏幕比组件要窄
      print("_screenSize.width < widgetSize.width");
      return;
    }
    if (_screenSize.height < widgetSize.height) {
      // 屏幕比组件要短
      print("_screenSize.height < widgetSize.height");
      return;
    }

    timerPeriodicCallback = () {
      _screenSize = MediaQuery.sizeOf(context);
      _screenSize = Size(_screenSize.width, _screenSize.height - 56);
      var xStep = Random.secure().nextInt(globalSetting.stepRandomMaxValue);
      var yStep = Random.secure().nextInt(globalSetting.stepRandomMaxValue);
      double left = positionMargin.left;
      double top = positionMargin.top;
      // x-axis
      if (_xOffsetReverse) {
        if (left - xStep > 0 && left - xStep + widgetSize.width < _screenSize.width) {
          left -= xStep;
        } else {
          left = 0;
          _xOffsetReverse = false;
        }
      } else {
        if (xStep + left + widgetSize.width < _screenSize.width) {
          left += xStep;
        } else {
          left = _screenSize.width - widgetSize.width;
          _xOffsetReverse = true;
        }
      }
      // y-axis
      if (_yOffsetReverse) {
        if (top - yStep > 0 && top - yStep + widgetSize.height < _screenSize.height) {
          top -= yStep;
        } else {
          top = 0;
          _yOffsetReverse = false;
        }
      } else {
        if (yStep + top + widgetSize.height < _screenSize.height) {
          top += yStep;
        } else {
          top = _screenSize.height - widgetSize.height;
          _yOffsetReverse = true;
        }
      }
      positionMargin = EdgeInsets.only(
          left: left,
          top: top
      );
      setState(() {}); // 更新
    };
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void dispose() {
    timerPeriodicCallback = null;
    super.dispose();
  }

}