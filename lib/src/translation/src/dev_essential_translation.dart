part of '../translation.dart';

class _TranslationHost {
  Locale? locale;

  Locale? fallbackLocale;

  Map<String, Map<String, String>> translations = {};
}

abstract class DevEssentialTranslations {
  Map<String, Map<String, String>> get keys;
}
