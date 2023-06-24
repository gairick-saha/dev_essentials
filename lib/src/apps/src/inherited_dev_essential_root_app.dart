part of '../apps.dart';

typedef InheritedDevEssentialRootApp = _InheritedDevEssentialRootApp;

class _InheritedDevEssentialRootApp extends InheritedWidget {
  const _InheritedDevEssentialRootApp({
    required Widget child,
    required this.devEssentialHook,
  }) : super(child: child);

  final DevEssentialHookState devEssentialHook;

  @override
  bool updateShouldNotify(covariant _InheritedDevEssentialRootApp oldWidget) =>
      true;
}
