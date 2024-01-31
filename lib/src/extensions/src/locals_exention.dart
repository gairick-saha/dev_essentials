part of '../extensions.dart';

extension LocalesIntl on DevEssential {
  static final _intlHost = DevEssentialTranslationHost();

  Locale? get locale => _intlHost.locale;

  Locale? get deviceLocale => engine.platformDispatcher.locale;

  Locale? get fallbackLocale => _intlHost.fallbackLocale;

  set locale(Locale? newLocale) => _intlHost.locale = newLocale;

  set fallbackLocale(Locale? newLocale) => _intlHost.fallbackLocale = newLocale;

  Map<String, Map<String, String>> get translations => _intlHost.translations;

  void addTranslations(Map<String, Map<String, String>> tr) {
    translations.addAll(tr);
  }

  void clearTranslations() {
    translations.clear();
  }

  void appendTranslations(Map<String, Map<String, String>> tr) {
    tr.forEach((key, map) {
      if (translations.containsKey(key)) {
        translations[key]!.addAll(map);
      } else {
        translations[key] = map;
      }
    });
  }

  Future<void> updateLocale(Locale l) async {
    Dev.locale = l;
    await forceAppUpdate();
  }
}

extension Trans on String {
  bool get _fullLocaleAndKey {
    return Dev.translations.containsKey(
            "${Dev.locale!.languageCode}_${Dev.locale!.countryCode}") &&
        Dev.translations[
                "${Dev.locale!.languageCode}_${Dev.locale!.countryCode}"]!
            .containsKey(this);
  }

  Map<String, String>? get _getSimilarLanguageTranslation {
    final translationsWithNoCountry = Dev.translations
        .map((key, value) => MapEntry(key.split("_").first, value));
    final containsKey = translationsWithNoCountry
        .containsKey(Dev.locale!.languageCode.split("_").first);

    if (!containsKey) {
      return null;
    }

    return translationsWithNoCountry[Dev.locale!.languageCode.split("_").first];
  }

  String get tr {
    if (Dev.locale?.languageCode == null) return this;

    if (_fullLocaleAndKey) {
      return Dev.translations[
          "${Dev.locale!.languageCode}_${Dev.locale!.countryCode}"]![this]!;
    }
    final similarTranslation = _getSimilarLanguageTranslation;
    if (similarTranslation != null && similarTranslation.containsKey(this)) {
      return similarTranslation[this]!;
    } else if (Dev.fallbackLocale != null) {
      final fallback = Dev.fallbackLocale!;
      final key = "${fallback.languageCode}_${fallback.countryCode}";

      if (Dev.translations.containsKey(key) &&
          Dev.translations[key]!.containsKey(this)) {
        return Dev.translations[key]![this]!;
      }
      if (Dev.translations.containsKey(fallback.languageCode) &&
          Dev.translations[fallback.languageCode]!.containsKey(this)) {
        return Dev.translations[fallback.languageCode]![this]!;
      }
      return this;
    } else {
      return this;
    }
  }

  String trArgs([List<String> args = const []]) {
    var key = tr;
    if (args.isNotEmpty) {
      for (final arg in args) {
        key = key.replaceFirst(RegExp(r'%s'), arg.toString());
      }
    }
    return key;
  }

  String trPlural([String? pluralKey, int? i, List<String> args = const []]) =>
      i == 1 ? trArgs(args) : pluralKey!.trArgs(args);

  String trParams([Map<String, String> params = const {}]) {
    var trans = tr;
    if (params.isNotEmpty) {
      params.forEach((key, value) {
        trans = trans.replaceAll('@$key', value);
      });
    }
    return trans;
  }

  String trPluralParams(
          [String? pluralKey, int? i, Map<String, String> params = const {}]) =>
      i == 1 ? trParams(params) : pluralKey!.trParams(params);
}
