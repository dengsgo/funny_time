import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_time/config.dart';

class PositionViewState<T extends StatefulWidget> extends State<T> {
  final timeViewKey = GlobalKey();
  EdgeInsets positionMargin = EdgeInsets.zero;
  VoidCallback? timerPeriodicCallback;
  bool _xOffsetReverse = false, _yOffsetReverse = false;

  addPostFrameCallback() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("addPostFrameCallback $timeStamp");
      resetBoxSizeValue();
      _centerWidget();
      SettingManager.addMetricsChangeCallback(_centerWidget);
      _motionWidget();
    });
  }

  resetBoxSizeValue() {
    final RenderObject? renderBox = timeViewKey.currentContext?.findRenderObject();
    print("renderBox ${renderBox?.paintBounds.size}");
    globalSetting.sharedTimeViewSize = renderBox?.paintBounds.size;
    globalSetting.sharedScreenSize = MediaQuery.sizeOf(context);
    print("_screenSize ${MediaQuery.of(context).size}");
  }

  _centerWidget() {
    if (globalSetting.sharedTimeViewSize == null) {
      return;
    }
    var widgetSize = globalSetting.sharedTimeViewSize!;
    var _screenSize = globalSetting.sharedScreenSize!;
    if (_screenSize.width < widgetSize.width) {
      // 屏幕比组件要窄
      _showErrorMessage("_centerWidget _screenSize.width < widgetSize.width");
      return;
    }
    if (_screenSize.height < widgetSize.height) {
      // 屏幕比组件要短
      _showErrorMessage("_centerWidget _screenSize.height < widgetSize.height");
      return;
    }
    double left = (_screenSize.width - widgetSize.width) / 2;
    double top = (_screenSize.height - widgetSize.height) / 2;
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
    if (globalSetting.sharedTimeViewSize == null) {
      return;
    }
    var widgetSize = globalSetting.sharedTimeViewSize!;
    var _screenSize = globalSetting.sharedScreenSize!;
    if (_screenSize.width < widgetSize.width) {
      // 屏幕比组件要窄
      print("_motionWidget _screenSize.width < widgetSize.width");
      return;
    }
    if (_screenSize.height < widgetSize.height) {
      // 屏幕比组件要短
      print("_motionWidget _screenSize.height < widgetSize.height");
      return;
    }

    timerPeriodicCallback = () {
      final RenderObject? renderBox = timeViewKey.currentContext?.findRenderObject();
      globalSetting.sharedTimeViewSize = renderBox?.paintBounds.size;
      widgetSize = globalSetting.sharedTimeViewSize!;
      _screenSize = MediaQuery.sizeOf(context);
      // print("MediaQuery.sizeOf(context) ${MediaQuery.sizeOf(context)}");
      globalSetting.sharedScreenSize = _screenSize; // 贡献给 global
      // print("globalSetting.sharedScreenSize ${globalSetting.sharedScreenSize}");
      var xStep = Random.secure().nextInt(globalSetting.stepRandomMaxValue);
      var yStep = Random.secure().nextInt(globalSetting.stepRandomMaxValue);
      double left = positionMargin.left;
      double top = positionMargin.top;
      bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
      var containerPadding = EdgeInsets.only(
        left: isPortrait ? 0.0 : positionPaddingHeight,
        right:  _screenSize.width,
        top: isPortrait ? positionPaddingHeight : 0.0,
        bottom: isPortrait ? _screenSize.height - positionPaddingHeight : _screenSize.height,
      );
      // print("containerPadding ${containerPadding.left},${containerPadding.top},${containerPadding.right},${containerPadding.bottom}");
      // x-axis
      if (_xOffsetReverse) {
        if (left - xStep > containerPadding.left) {
          left -= xStep;
        } else {
          left = containerPadding.left;
          _xOffsetReverse = false;
        }
      } else {
        if (left + xStep + widgetSize.width < containerPadding.right - globalSetting.stepRandomMaxValue) {
          left += xStep;
        } else {
          left = containerPadding.right - widgetSize.width - globalSetting.stepRandomMaxValue;
          _xOffsetReverse = true;
        }
      }
      // y-axis
      if (_yOffsetReverse) {
        if (top - yStep > containerPadding.top) {
          top -= yStep;
        } else {
          top = containerPadding.top;
          _yOffsetReverse = false;
        }
      } else {
        if (top + yStep + widgetSize.height < containerPadding.bottom - globalSetting.stepRandomMaxValue) {
          top += yStep;
        } else {
          top = containerPadding.bottom - widgetSize.height - globalSetting.stepRandomMaxValue;
          _yOffsetReverse = true;
        }
      }
      // 如果出现显示异常，做最后的修正
      if (left + widgetSize.width >= containerPadding.right) {
        return _centerWidget();
      }
      if (top + widgetSize.height >= containerPadding.bottom) {
        return _centerWidget();
      }
      positionMargin = EdgeInsets.only(
          left: left,
          top: top
      );
      // print("left + widgetSize.width > containerPadding.right ${left + widgetSize.width >= containerPadding.right}");
      // print("top + widgetSize.height > containerPadding.bottom ${top + widgetSize.height >= containerPadding.bottom}");
      // print("positionMargin $positionMargin");
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

  _showErrorMessage(Object? object) {
    print(object);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$object"), action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),)
    );
  }

}