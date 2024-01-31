// ignore_for_file: non_constant_identifier_names

part of '../utils.dart';

class EnumToString {
  static bool _isEnumItem(enumItem) {
    final split_enum = enumItem.toString().split('.');
    return split_enum.length > 1 &&
        split_enum[0] == enumItem.runtimeType.toString();
  }

  static String convertToString(dynamic enumItem, {bool camelCase = false}) {
    assert(enumItem != null);
    assert(_isEnumItem(enumItem),
        '$enumItem of type ${enumItem.runtimeType.toString()} is not an enum item');
    final tmp = enumItem.toString().split('.')[1];
    return !camelCase ? tmp : camelCaseToWords(tmp);
  }

  @Deprecated(
      'Renamed function to EnumToString.convertToString to make it clearer')
  static String parse(enumItem, {bool camelCase = false}) =>
      convertToString(enumItem, camelCase: camelCase);

  @Deprecated(
      'Deprecated in favour of using convertToString(item, camelCase: true)')
  static String parseCamelCase(enumItem) {
    return EnumToString.convertToString(enumItem, camelCase: true);
  }

  static T? fromString<T>(List<T> enumValues, String value,
      {bool camelCase = false}) {
    try {
      return enumValues.singleWhere((enumItem) =>
          EnumToString.convertToString(enumItem, camelCase: camelCase)
              .toLowerCase() ==
          value.toLowerCase());
    } on StateError catch (_) {
      return null;
    }
  }

  static int indexOf<T>(List<T> enumValues, String value) {
    final fromStringResult = fromString<T>(enumValues, value);
    if (fromStringResult == null) {
      return -1;
    } else {
      return enumValues.indexOf(fromStringResult);
    }
  }

  static List<String> toList<T>(List<T> enumValues, {bool camelCase = false}) {
    final enumList = enumValues
        .map((t) => !camelCase
            ? EnumToString.convertToString(t)
            : EnumToString.convertToString(t, camelCase: true))
        .toList();

    var output = <String>[];
    for (var value in enumList) {
      output.add(value);
    }
    return output;
  }

  static List<T?> fromList<T>(List<T> enumValues, List valueList) {
    return List<T?>.from(
        valueList.map<T?>((item) => fromString(enumValues, item)));
  }
}
