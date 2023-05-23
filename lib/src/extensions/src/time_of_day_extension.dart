part of '../extensions.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime convertToDateTime(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      hour,
      minute,
    );
  }
}
