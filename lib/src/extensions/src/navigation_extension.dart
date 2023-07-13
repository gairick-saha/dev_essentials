part of '../extensions.dart';

extension NavigationExtension on DevEssential {
  static final DevEssentialHookState _hookState =
      DevEssentialHookState.instance;

  DevEssentialRoutingTree get routingTree => _hookState.routingTree;

  DevEssentialRouting get routing => _hookState.routing;

  GlobalKey<NavigatorState> get key => _hookState.rootNavigatorKey;

  Map<Object, GlobalKey<NavigatorState>> get nestedNavigatorKeys =>
      _hookState.nestedNavigatorKeys;

  String? get currentRoute => routing.currentRoute;

  String? get previousRoute => routing.previousRoute;

  NavigatorState? get navigator => NavigationExtension(Dev).key.currentState;

  Object? get arguments => routing.arguments;

  Map<String, String> get parameters => _hookState.parameters;

  GlobalKey<NavigatorState> nestedKey(Object key) =>
      _hookState.addNestedNavigatorKey(key);

  GlobalKey<NavigatorState> _global(Object? k) {
    GlobalKey<NavigatorState> navKey;

    if (k == null) {
      navKey = key;
    } else {
      if (!nestedNavigatorKeys.containsKey(k)) {
        throw 'Navigator with id ($k) not found';
      }
      navKey = nestedNavigatorKeys[k]!;
    }

    if (navKey.currentContext == null) {
      throw """You are trying to use contextless navigation without a DevEssentialMaterialApp.""";
    }

    return navKey;
  }

  WidgetBuilder _resolvePage(dynamic page, String method) {
    if (page is WidgetBuilder) {
      return page;
    } else if (page is Widget) {
      // Dev.print(
      //   'WARNING, consider using: "Dev.$method(() => Page())" instead of "Dev.$method(Page())". Using a widget function instead of a widget fully guarantees that the widget and its controllers will be removed from memory when they are no longer used.',
      // );
      return (BuildContext context) => page;
    } else if (page is String) {
      throw 'Unexpected String, use toNamed() instead';
    } else {
      throw 'Unexpected format, you can only use widgets and widget functions here';
    }
  }

  String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');
    name = name.replaceAll('(BuildContext context) => ', '');
    name = name.replaceAll('(context) => ', '');

    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }

  bool get isSnackbarOpen =>
      DevEssentialSnackbarController.isSnackbarBeingShown;

  void closeAllSnackbars() =>
      DevEssentialSnackbarController.cancelAllSnackbars();

  Future<void> closeCurrentSnackbar() async =>
      await DevEssentialSnackbarController.closeCurrentSnackbar();

  bool get isDialogOpen => routing.isDialog;

  bool get isBottomSheetOpen => routing.isBottomSheet;

  Route<dynamic>? get rawRoute => routing.route;

  bool get isOverlaysOpen =>
      isSnackbarOpen || isDialogOpen || isBottomSheetOpen;

  bool get isOverlaysClosed =>
      !isSnackbarOpen && !isDialogOpen && !isBottomSheetOpen;

  void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    Object? id,
  }) {
    if (isSnackbarOpen && !closeOverlays) {
      closeCurrentSnackbar();
      return;
    }

    if (closeOverlays && isOverlaysOpen) {
      if (isSnackbarOpen) {
        closeAllSnackbars();
      }
      navigator?.popUntil((route) {
        return (!isDialogOpen && !isBottomSheetOpen);
      });
    }

    if (canPop) {
      if (_global(id).currentState?.canPop() == true) {
        _global(id).currentState?.pop<T>(result);
      }
    } else {
      _global(id).currentState?.pop<T>(result);
    }
  }

  bool canGoBack({Object? id}) => _global(id).currentState?.canPop() == true;

  Future<bool> handleNestedNavigationBackButton({
    required Object? navigatorId,
    OnAppCloseCallback? onAppCloseCallback,
  }) async {
    if (canGoBack(id: navigatorId)) {
      back(id: navigatorId);
    } else if (canGoBack()) {
      back();
    } else if (onAppCloseCallback != null) {
      return await onAppCloseCallback();
    } else {
      return true;
    }

    return false;
  }

  Future<T?> to<T>(
    dynamic page, {
    Object? id,
    String? routeName,
    dynamic arguments,
    Map<String, String>? parameters,
    DevEssentialTransition? transition,
    Curve? curve,
    DevEssentialCustomTransition? customTransition,
  }) async {
    routeName ??= "/${page.runtimeType}";
    if (routeName == currentRoute) {
      return null;
    }
    return _global(id).currentState?.push<T>(
          DevEssentialRoute<T>(
            name: routeName,
            arguments: arguments,
            parameters: parameters,
            pageBuilder: _resolvePage(page, 'to'),
            transition: transition,
            curve: curve,
            customTransition: customTransition,
          ),
        );
  }

  Future<T?>? off<T>(
    dynamic page, {
    Object? id,
    String? routeName,
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    routeName ??= "/${page.runtimeType.toString()}";
    routeName = _cleanRouteName(routeName);
    if (routeName == currentRoute) {
      return null;
    }
    return _global(id).currentState?.pushReplacement(
          DevEssentialRoute(
            pageBuilder: _resolvePage(page, 'off'),
            arguments: arguments,
            name: routeName,
            parameters: parameters,
          ),
        );
  }

  Future<T?>? toNamed<T>(
    String routeName, {
    Object? arguments,
    Object? id,
    Map<String, String>? parameters,
  }) {
    String newRoute = routeName;
    if (routeName == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final Uri uri = Uri(path: routeName, queryParameters: parameters);
      newRoute = uri.toString();
    }

    return _global(id).currentState?.pushNamed<T>(
          newRoute,
          arguments: arguments,
        );
  }

  Future<T?>? offNamed<T>(
    String routeName, {
    Object? arguments,
    Object? id,
    Map<String, String>? parameters,
  }) {
    if (routeName == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final Uri uri = Uri(path: routeName, queryParameters: parameters);
      routeName = uri.toString();
    }

    return _global(id).currentState?.pushReplacementNamed(
          routeName,
          arguments: arguments,
        );
  }

  void until(RoutePredicate predicate, {Object? id}) =>
      _global(id).currentState?.popUntil(predicate);

  Future<T?>? offUntil<T>(Route<T> page, RoutePredicate predicate,
          {Object? id}) =>
      _global(id).currentState?.pushAndRemoveUntil<T>(page, predicate);

  Future<T?>? offNamedUntil<T>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? id,
    Object? arguments,
    Map<String, String>? parameters,
  }) {
    if (newRouteName == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final Uri uri = Uri(path: newRouteName, queryParameters: parameters);
      newRouteName = uri.toString();
    }

    return _global(id).currentState?.pushNamedAndRemoveUntil<T>(
          newRouteName,
          predicate,
          arguments: arguments,
        );
  }

  Future<T?>? offAndToNamed<T>(
    String routeName, {
    dynamic arguments,
    Map<String, String>? parameters,
    Object? id,
    Object? result,
  }) {
    if (routeName == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final uri = Uri(path: routeName, queryParameters: parameters);
      routeName = uri.toString();
    }
    return _global(id).currentState?.popAndPushNamed(
          routeName,
          arguments: arguments,
          result: result,
        );
  }

  void removeRoute(Route<dynamic> route, {Object? id}) =>
      _global(id).currentState?.removeRoute(route);

  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    Object? id,
    RoutePredicate? predicate,
    Object? arguments,
    Map<String, String>? parameters,
  }) {
    if (newRouteName == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final Uri uri = Uri(path: newRouteName, queryParameters: parameters);
      newRouteName = uri.toString();
    }

    return _global(id).currentState?.pushNamedAndRemoveUntil<T>(
          newRouteName,
          predicate ?? (_) => false,
          arguments: arguments,
        );
  }

  Route<DevEssentialRoute> routeGenerator({
    required RouteSettings settings,
    DevEssentialPage? unknownRoute,
    bool isNestedRouting = false,
  }) =>
      PagePredict(
        settings: settings,
        unknownRoute: unknownRoute ?? DevEssentialPages.defaultUnknownRoute,
      ).page();

  List<Route<dynamic>> initialRouteGenerator(
    String name, {
    DevEssentialPage? unknownRoute,
  }) =>
      PagePredict(
        settings: RouteSettings(name: name),
        unknownRoute: unknownRoute ?? DevEssentialPages.defaultUnknownRoute,
      ).initialRouteName();

  DevEssentialNavigationObserver navigatorObserver({
    bool isNestedRouting = false,
  }) =>
      DevEssentialNavigationObserver(
        routing: routing,
        isNestedRouting: isNestedRouting,
      );
}
