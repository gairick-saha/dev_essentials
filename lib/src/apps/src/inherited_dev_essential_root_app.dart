part of '../apps.dart';

typedef InheritedDevEssentialRootApp = _InheritedDevEssentialRootApp;

class _InheritedDevEssentialRootApp extends InheritedWidget {
  const _InheritedDevEssentialRootApp({
    required Widget child,
    required this.devEssentialHook,
    // required this.splashConfig,
  }) : super(child: child);

  final DevEssentialHookState devEssentialHook;
  // final SplashConfig? splashConfig;

  @override
  bool updateShouldNotify(covariant _InheritedDevEssentialRootApp oldWidget) =>
      true;
}
