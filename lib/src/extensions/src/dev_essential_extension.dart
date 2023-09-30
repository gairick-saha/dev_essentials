part of '../extensions.dart';

extension DevEssentialExtension on DevEssential {
  DevEssentialHookState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedDevEssentialRootApp>()!
      .devEssentialHook;

  void print(dynamic message, {String? name}) {
    if (kDebugMode) {
      log((message).toString(), name: name ?? 'DevEssential');
    }
  }

  WidgetsBinding get widgetsBinding => Engine.widgetsBinding;

  SchedulerBinding get schedulerBinding => Engine.schedulerBinding;

  Future<String?> downloadFile(String url) async => await url.download;

  static final DevEssentialHookState _hookState =
      DevEssentialHookState.instance;

  bool get defaultPopGesture => _hookState.defaultPopGesture;

  bool get defaultOpaqueRoute => _hookState.defaultOpaqueRoute;

  DevEssentialTransition? get defaultTransition => _hookState.defaultTransition;

  Duration get defaultTransitionDuration =>
      _hookState.defaultTransitionDuration;

  Curve get defaultTransitionCurve => _hookState.defaultTransitionCurve;

  Curve get defaultDialogTransitionCurve =>
      _hookState.defaultDialogTransitionCurve;

  Duration get defaultDialogTransitionDuration =>
      _hookState.defaultDialogTransitionDuration;

  DevEssentialCustomTransition? get customTransition =>
      _hookState.customTransition;

  set customTransition(DevEssentialCustomTransition? newTransition) =>
      _hookState.customTransition = newTransition;

  TextDirection get textDirection =>
      intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)
          ? TextDirection.rtl
          : TextDirection.ltr;
}
