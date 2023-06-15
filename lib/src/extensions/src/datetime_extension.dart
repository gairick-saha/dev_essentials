part of '../extensions.dart';

extension FormateDateTimeExtension on DateTime {
  String toEEEdMMMy() {
    return DateFormat('EEE, d MMM y').format(this);
  }

  String toEEEdMMM() {
    return DateFormat('EEE, d MMM').format(this);
  }

  String toEEEdMMMyyyy() {
    return DateFormat('EEE, d MMM yyyy').format(this);
  }

  String toddMMyyyy() {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String toddMMM() {
    return DateFormat('dd MMM').format(this);
  }

  String tod() {
    return DateFormat('d').format(this);
  }

  String tom() {
    return DateFormat('MMM').format(this);
  }

  String toEEE() {
    return DateFormat('EEE').format(this);
  }

  String todMMM() {
    return DateFormat('d MMM').format(this);
  }

  String time12HourFormat() {
    return DateFormat('hh:mm a').format(this);
  }

  String time24HourFormat() {
    return DateFormat('HH:mm').format(this);
  }

  String custom(String? pattern) {
    return DateFormat(pattern ?? 'hh:mm a - dd MMM yyyy').format(this);
  }

  String toddMMMyyyy() {
    return DateFormat('dd MMM, yyyy').format(this);
  }

  String tohm() {
    return DateFormat.jm().format(this);
  }

  String toyyyyMMdd() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  int getAge() {
    final today = DateTime.now();

    if (isAfter(today)) {
      return 0;
    }
    int age = today.year - year;
    final m = today.month - month;
    if (m < 0 || (m == 0 && today.day < day)) {
      /// if month difference is less than zero if not month difference is zero and today is  before  dob day, decrement age by one

      age--;
    }
    return age;
  }

  bool isToday() {
    final DateTime now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final DateTime yesterday =
        DateTime.now().subtract(const Duration(hours: 24));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool isTomorrow() {
    final DateTime yesterday = DateTime.now().add(const Duration(hours: 24));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}
