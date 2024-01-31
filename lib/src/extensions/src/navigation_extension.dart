part of '../extensions.dart';

extension DevEssentialPagesListExt on List<DevEssentialPage> {
  Iterable<DevEssentialPage> pickFromRoute(String route) {
    return skipWhile((value) => value.name != route);
  }

  Iterable<DevEssentialPage> pickAfterRoute(String route) {
    if (route == '/') {
      return pickFromRoute(route).skip(1).take(1);
    }

    return pickFromRoute(route).skip(1);
  }
}

extension NavigationExtension on DevEssential {
  bool get defaultPopGesture => _appConfig.defaultPopGesture;

  bool get defaultOpaqueRoute => _appConfig.defaultOpaqueRoute;

  DevEssentialTransition? get defaultTransition => _appConfig.defaultTransition;

  Duration get defaultTransitionDuration =>
      _appConfig.defaultTransitionDuration;

  Curve get defaultTransitionCurve => _appConfig.defaultTransitionCurve;

  Curve get defaultDialogTransitionCurve =>
      _appConfig.defaultDialogTransitionCurve;

  Duration get defaultDialogTransitionDuration =>
      _appConfig.defaultDialogTransitionDuration;

  DevEssentialCustomTransition? get customTransition =>
      _appConfig.customTransition;

  DevEssentialRouting get routing => _appConfig.routing;

  void appUpdate() => _hookState.update();

  void changeTheme(ThemeData theme) => _hookState.setTheme(theme);

  void changeThemeMode(ThemeMode themeMode) =>
      _hookState.setThemeMode(themeMode);

  GlobalKey<NavigatorState>? addKey(GlobalKey<NavigatorState> newKey) =>
      _hookState.addKey(newKey);

  DevEssentialRouterDelegate get rootDelegate => _hookState.rootDelegate;

  TDelegate? delegate<TDelegate extends RouterDelegate<TPage>, TPage>() =>
      _appConfig.routerDelegate as TDelegate?;

  GlobalKey<NavigatorState> get key => _hookState.key;

  Map<String, DevEssentialRouterDelegate> get keys => _hookState.keys;

  DevEssentialRouterDelegate? nestedKey(String? key) =>
      _hookState.nestedKey(key);

  String? get currentRoute => routing.current;

  String? get previousRoute => routing.previous;

  dynamic get arguments => rootDelegate.arguments();

  Map<String, String?> get parameters => _hookState.rootDelegate.parameters;

  set parameters(Map<String, String?> newParameters) =>
      _hookState.parameters = newParameters;

  bool get isDialogOpen => routing.isDialog;

  bool get isBottomSheetOpen => routing.isBottomSheet;

  Route<dynamic>? get rawRoute => routing.route;

  bool get isPopGestureEnable => defaultPopGesture;

  bool get isOpaqueRouteDefault => defaultOpaqueRoute;

  DevEssentialPageRoutePredicate withName(String name) =>
      rootDelegate.withName(name);

  DevEssentialRouterDelegate searchDelegate(String? k) {
    DevEssentialRouterDelegate key;
    if (k == null) {
      key = rootDelegate;
    } else {
      if (!keys.containsKey(k)) {
        throw 'Route id ($k) not found';
      }
      key = keys[k]!;
    }

    return key;
  }

  Future<T?>? to<T extends Object?>(
    Widget page, {
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
    bool rebuildStack = true,
    PreventDuplicateHandlingMode preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
  }) {
    return searchDelegate(id).to(
      (_, __) => page,
      opaque: opaque,
      transition: transition,
      curve: curve,
      duration: duration,
      id: id,
      routeName: routeName,
      fullscreenDialog: fullscreenDialog,
      arguments: arguments,
      preventDuplicates: preventDuplicates,
      popGesture: popGesture,
      showCupertinoParallax: showCupertinoParallax,
      gestureWidth: gestureWidth,
      rebuildStack: rebuildStack,
      preventDuplicateHandlingMode: preventDuplicateHandlingMode,
    );
  }

  Future<T?>? toNamed<T>(
    String page, {
    dynamic arguments,
    String? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return searchDelegate(id).toNamed(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }

  Future<T?>? offNamed<T>(
    String page, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return searchDelegate(id).offNamed(
      page,
      arguments: arguments,
      id: id,
      parameters: parameters,
    );
  }

  void until(DevEssentialPageRoutePredicate predicate, {String? id}) =>
      searchDelegate(id).backUntil(predicate);

  Future<T?>? offNamedUntil<T>(
    String page,
    DevEssentialPageRoutePredicate? predicate, {
    String? id,
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return searchDelegate(id).offNamedUntil<T>(
      page,
      predicate: predicate,
      id: id,
      arguments: arguments,
      parameters: parameters,
    );
  }

  Future<T?>? offAndToNamed<T>(
    String page, {
    dynamic arguments,
    String? id,
    dynamic result,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return searchDelegate(id).backAndtoNamed(
      page,
      arguments: arguments,
      result: result,
    );
  }

  void removeRoute(String name, {String? id}) {
    return searchDelegate(id).removeRoute(name);
  }

  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final uri = Uri(path: newRouteName, queryParameters: parameters);
      newRouteName = uri.toString();
    }

    return searchDelegate(id).offAllNamed<T>(
      newRouteName,
      arguments: arguments,
      id: id,
      parameters: parameters,
    );
  }

  void back<T>({
    T? result,
    bool canPop = true,
    int times = 1,
    String? id,
  }) {
    if (times < 1) {
      times = 1;
    }

    if (times > 1) {
      var count = 0;
      return searchDelegate(id).backUntil((route) => count++ == times);
    } else {
      if (canPop) {
        if (searchDelegate(id).canBack == true) {
          return searchDelegate(id).back<T>(result);
        }
      } else {
        return searchDelegate(id).back<T>(result);
      }
    }
  }

  Future<T?>? off<T>(
    DevEssentialPageBuilder page, {
    bool? opaque,
    DevEssentialTransition? transition,
    Curve? curve,
    bool? popGesture,
    String? id,
    String? routeName,
    dynamic arguments,
    bool fullscreenDialog = false,
    bool preventDuplicates = true,
    Duration? duration,
    double Function(BuildContext context)? gestureWidth,
  }) {
    routeName ??= "/${page.runtimeType.toString()}";
    routeName = _hookState.cleanRouteName(routeName);
    if (preventDuplicates && routeName == currentRoute) {
      return null;
    }
    return searchDelegate(id).off(
      page,
      opaque: opaque ?? true,
      transition: transition,
      curve: curve,
      popGesture: popGesture,
      id: id,
      routeName: routeName,
      arguments: arguments,
      fullscreenDialog: fullscreenDialog,
      preventDuplicates: preventDuplicates,
      duration: duration,
      gestureWidth: gestureWidth,
    );
  }

  Future<T?> offUntil<T>(
    DevEssentialPageBuilder page,
    bool Function(DevEssentialPage) predicate, [
    Object? arguments,
    String? id,
  ]) {
    return searchDelegate(id).offUntil(
      page,
      predicate,
      arguments,
    );
  }

  Future<T?>? offAll<T>(
    DevEssentialPageBuilder page, {
    DevEssentialPageRoutePredicate? predicate,
    bool? opaque,
    bool? popGesture,
    String? id,
    String? routeName,
    dynamic arguments,
    bool fullscreenDialog = false,
    DevEssentialTransition? transition,
    Curve? curve,
    Duration? duration,
    double Function(BuildContext context)? gestureWidth,
  }) {
    routeName ??= "/${page.runtimeType.toString()}";
    routeName = _hookState.cleanRouteName(routeName);
    return searchDelegate(id).offAll<T>(
      page,
      predicate: predicate,
      opaque: opaque ?? true,
      popGesture: popGesture,
      id: id,
      arguments: arguments,
      fullscreenDialog: fullscreenDialog,
      transition: transition,
      curve: curve,
      duration: duration,
      gestureWidth: gestureWidth,
    );
  }
}
