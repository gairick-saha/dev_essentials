part of '../extensions.dart';

extension NumExtension on num {
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  Duration get minutes =>
      Duration(seconds: (this * Duration.secondsPerMinute).round());

  Duration get hours =>
      Duration(minutes: (this * Duration.minutesPerHour).round());

  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());

  double get percentage => this * (this / 100);

  double get percentageHeight => Dev.height * (this / 100);

  double get percentageWidth => Dev.width * (this / 100);

  Object get convertBytestoGB =>
      this == 0 ? 0 : (this / math.pow(1000, 3)).toStringAsFixed(2);
}
