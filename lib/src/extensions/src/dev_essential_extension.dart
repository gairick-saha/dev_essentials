part of '../extensions.dart';

extension DevEssentialExtension on DevEssential {
  void print(dynamic message, {String? name}) =>
      defaultLogWriterCallback(message, name: name);

  WidgetsBinding get engine => Engine.instance;

  SchedulerBinding get schedulerBinding => Engine.schedulerBinding;

  Future<String?> downloadFile(String url) async => await url.download;

  Future<void> forceAppUpdate() async => await engine.performReassemble();

  DevEssentialHookState get _hookState => DevEssentialHookState.instance;

  DevEssentialAppConfigData get _appConfig => _hookState.config;

  BuildContext get context => key.currentContext!;

  BuildContext? get overlayContext {
    BuildContext? overlay;
    key.currentState?.overlay?.context.visitChildElements((element) {
      overlay = element;
    });
    return overlay;
  }

  FocusNode? get focusScope => FocusManager.instance.primaryFocus;

  Color get randomColor => DevEssentialUtility.getRandomColor();

  TextDirection get textDirection =>
      intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)
          ? TextDirection.rtl
          : TextDirection.ltr;
}
