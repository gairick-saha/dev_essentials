part of '../extensions.dart';

extension NavigationExtension on DevEssential {
  static final DevEssentialHookState _hookState =
      DevEssentialHookState.instance;

  DevEssentialRoutingTree get routingTree => _hookState.routingTree;

  DevEssentialRouting get routing => _hookState.routing;

  DevEssentialRoutingTree get nestedRoutingTree => _hookState.nestedRoutingTree;

  DevEssentialRouting get nestedRouting => _hookState.nestedRouting;

  GlobalKey<NavigatorState> get key => _hookState.rootNavigatorKey;

  Map<Object, GlobalKey<NavigatorState>> get nestedNavigatorKeys =>
      _hookState.nestedNavigatorKeys;

  String? currentRoute(bool isNestedRouting) =>
      isNestedRouting ? nestedRouting.currentRoute : routing.currentRoute;

  String? previousRoute(bool isNestedRouting) =>
      isNestedRouting ? nestedRouting.previousRoute : routing.previousRoute;

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
      Dev.print(
        'WARNING, consider using: "Dev.$method(() => Page())" instead of "Dev.$method(Page())". Using a widget function instead of a widget fully guarantees that the widget and its controllers will be removed from memory when they are no longer used.',
      );
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

  NavigatorState? get navigator => NavigationExtension(Dev).key.currentState;

  void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    if (canPop) {
      if (_global(id).currentState?.canPop() == true) {
        _global(id).currentState?.pop<T>(result);
      }
    } else {
      _global(id).currentState?.pop<T>(result);
    }
  }

  Future<T?> to<T>(
    dynamic page, {
    int? id,
    String? routeName,
    dynamic arguments,
  }) async {
    routeName ??= "/${page.runtimeType}";
    if (routeName == currentRoute(id != null)) {
      return null;
    }
    return _global(id).currentState?.push<T>(
          DevEssentialRoute<T>(
            settings: RouteSettings(
              name: routeName,
              arguments: arguments,
            ),
            pageBuilder: _resolvePage(page, 'to'),
          ),
        );
  }

  Future<T?>? off<T>(
    dynamic page, {
    int? id,
    String? routeName,
    dynamic arguments,
  }) {
    routeName ??= "/${page.runtimeType.toString()}";
    routeName = _cleanRouteName(routeName);
    if (routeName == currentRoute(id != null)) {
      return null;
    }
    return _global(id).currentState?.pushReplacement(
          DevEssentialRoute(
            pageBuilder: _resolvePage(page, 'off'),
            settings: RouteSettings(
              arguments: arguments,
              name: routeName,
            ),
          ),
        );
  }

  Future<T?>? toNamed<T>(
    String routeName, {
    Object? arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    if (routeName == currentRoute(id != null)) {
      return null;
    }

    if (parameters != null) {
      final Uri uri = Uri(path: routeName, queryParameters: parameters);
      routeName = uri.toString();
    }

    return _global(id).currentState?.pushNamed<T>(
          routeName,
          arguments: arguments,
        );
  }

  Future<T?>? offNamed<T>(
    String routeName, {
    Object? arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    if (routeName == currentRoute(id != null)) {
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

  void until(RoutePredicate predicate, {int? id}) =>
      _global(id).currentState?.popUntil(predicate);

  Future<T?>? offUntil<T>(Route<T> page, RoutePredicate predicate, {int? id}) =>
      _global(id).currentState?.pushAndRemoveUntil<T>(page, predicate);

  Future<T?>? offNamedUntil<T>(
    String newRouteName,
    RoutePredicate predicate, {
    int? id,
    Object? arguments,
    Map<String, String>? parameters,
  }) {
    if (newRouteName == currentRoute(id != null)) {
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
    int? id,
    Object? result,
    Map<String, String>? parameters,
  }) {
    if (routeName == currentRoute(id != null)) {
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

  void removeRoute(Route<dynamic> route, {int? id}) =>
      _global(id).currentState?.removeRoute(route);

  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    RoutePredicate? predicate,
    Object? arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    if (newRouteName == currentRoute(id != null)) {
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

  Route<DevEssentialRoute> onGenerateRoute({
    required RouteSettings settings,
    DevEssentialPage? unknownRoute,
    bool isNestedRouting = false,
  }) =>
      PagePredict(
        settings: settings,
        unknownRoute: unknownRoute ?? DevEssentialPages.defaultUnknownRoute,
      ).page(
        isNestedRouting: isNestedRouting,
      );

  List<Route<dynamic>> initialRoutesGenerate(
    String name, {
    DevEssentialPage? unknownRoute,
    bool isNestedRouting = false,
  }) =>
      [
        PagePredict(
          settings: RouteSettings(name: name),
          unknownRoute: unknownRoute ?? DevEssentialPages.defaultUnknownRoute,
        ).page(
          isNestedRouting: isNestedRouting,
        ),
      ];

  DevEssentialNavigationObserver navigatorObserver(
          {bool isNestedRouting = false}) =>
      DevEssentialNavigationObserver(
        routing: isNestedRouting ? nestedRouting : routing,
        isNestedRouting: isNestedRouting,
      );

  Future<bool> handleNestedNavigationBackButton() async {
    return false;
  }
}
