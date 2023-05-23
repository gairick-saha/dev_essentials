part of '../extensions.dart';

extension DurationExtension on Duration {
  String getDurationInString() {
    String twoDigits(int n, String suff) {
      if (n != 0) {
        return n.toString() + suff;
      } else {
        return '';
      }
    }

    String twoDigitMinutes = twoDigits(inMinutes.remainder(60), 'm');

    return "${twoDigits(inHours, "h")} $twoDigitMinutes";
  }
}
