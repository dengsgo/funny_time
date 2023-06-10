import 'dart:async';
import 'dart:math';

typedef TimerPeriodicCallback = void Function(Timer);

enum TimerFrequency {
  second(Duration(seconds: 1)),
  slowSecond(Duration(seconds: 3)),
  minute(Duration(minutes: 1)),
  halfHour(Duration(minutes: 15)),
  ;
  const TimerFrequency(this.duration);
  final Duration duration;
}

class TimerEvent {
  const TimerEvent({required this.key, required this.frequency, required this.callback});
  final String key;
  final TimerFrequency frequency;
  final TimerPeriodicCallback callback;

  start() {}

  stop() {}

}

class Event {

  static Timer? _secondTimer;
  static Timer? _slowSecondTimer;
  static Timer? _minuteTimer;

  static final Map<String, TimerPeriodicCallback> _secondCallback = {};
  static final Map<String, TimerPeriodicCallback> _slowSecondCallback = {};
  static final Map<String, TimerPeriodicCallback> _minuteCallback = {};

  static addTimerPeriodic(TimerEvent event) {
    if (event.frequency == TimerFrequency.minute || event.frequency == TimerFrequency.halfHour) {

    }
  }

  static applyForTimer() {}

}