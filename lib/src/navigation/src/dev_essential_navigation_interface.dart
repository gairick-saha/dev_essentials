part of '../navigation.dart';

typedef DevEssentialPageRoutePredicate = bool Function(
    DevEssentialPage<dynamic> route);

mixin DevEssentialNavigationInterface {
  Future<T?> to<T>(
    DevEssentialPageBuilder page, {
    bool? opaque,
    DevEssentialTransition? transition,
    Curve? curve,
    Duration? duration,
    String? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    bool preventDuplicates = true,
    bool? popGesture,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  });

  Future<void> popModeUntil(
    String fullRoute, {
    PopMode popMode = PopMode.history,
  });

  Future<T?> off<T>(
    DevEssentialPageBuilder page, {
    bool? opaque,
    DevEssentialTransition? transition,
    Curve? curve,
    Duration? duration,
    String? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    bool preventDuplicates = true,
    bool? popGesture,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  });

  Future<T?>? offAll<T>(
    DevEssentialPageBuilder page, {
    DevEssentialPageRoutePredicate? predicate,
    bool opaque = true,
    bool? popGesture,
    String? id,
    String? routeName,
    dynamic arguments,
    bool fullscreenDialog = false,
    DevEssentialTransition? transition,
    Curve? curve,
    Duration? duration,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  });

  Future<T?> toNamed<T>(
    String page, {
    dynamic arguments,
    String? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  });

  Future<T?> offNamed<T>(
    String page, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  });

  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  });

  Future<T?>? offNamedUntil<T>(
    String page, {
    DevEssentialPageRoutePredicate? predicate,
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  });

  Future<T?> toNamedAndOffUntil<T>(
    String page,
    DevEssentialPageRoutePredicate predicate, [
    Object? data,
  ]);

  Future<T?> offUntil<T>(
    DevEssentialPageBuilder page,
    DevEssentialPageRoutePredicate predicate, [
    Object? arguments,
  ]);

  void removeRoute<T>(String name);

  void back<T>([T? result]);

  Future<R?> backAndtoNamed<T, R>(String page, {T? result, Object? arguments});

  void backUntil(DevEssentialPageRoutePredicate predicate);

  void goToUnknownPage([bool clearPages = true]);
}
