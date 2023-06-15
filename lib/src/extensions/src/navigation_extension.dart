part of '../extensions.dart';

extension NavigationExtension on DevEssential {
  static final DevEssentialHookState _hookState =
      DevEssentialHookState.instance;

  DevEssentialRouting get routing => _hookState.routing;

  GlobalKey<NavigatorState> get key => routing.rootNavigatorKey;

  Map<int, GlobalKey<NavigatorState>> get nestedNavigatorKeys =>
      routing.nestedNavigatorKeys;

  String? get currentRoute => routing.currentRoute;

  String? get previousRoute => routing.previousRoute;

  GlobalKey<NavigatorState>? nestedKey(int key) {
    nestedNavigatorKeys.putIfAbsent(
      key,
      () => GlobalKey<NavigatorState>(
        debugLabel: 'DevEssential nested key: ${key.toString()}',
      ),
    );
    return nestedNavigatorKeys[key];
  }

  GlobalKey<NavigatorState> _global(int? k) {
    GlobalKey<NavigatorState> newKey;

    if (k == null) {
      newKey = key;
    } else {
      if (!nestedNavigatorKeys.containsKey(k)) {
        throw 'Navigator with id ($k) not found';
      }
      newKey = nestedNavigatorKeys[k]!;
    }

    if (newKey.currentContext == null) {
      throw """You are trying to use contextless navigation without a DevEssentialMaterialApp.""";
    }

    return newKey;
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
    bool preventDuplicates = true,
  }) async {
    routeName ??= "/${page.runtimeType}";
    if (preventDuplicates && routeName == currentRoute) {
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
    bool preventDuplicates = true,
  }) {
    routeName ??= "/${page.runtimeType.toString()}";
    routeName = _cleanRouteName(routeName);
    if (preventDuplicates && routeName == currentRoute) {
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
    String route, {
    Object? arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    if (route == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final Uri uri = Uri(path: route, queryParameters: parameters);
      route = uri.toString();
    }

    return _global(id).currentState?.pushNamed<T>(
          route,
          arguments: arguments,
        );
  }

  Future<T?>? offNamed<T>(
    String route, {
    Object? arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    if (route == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final Uri uri = Uri(path: route, queryParameters: parameters);
      route = uri.toString();
    }

    return _global(id).currentState?.pushReplacementNamed(
          route,
          arguments: arguments,
        );
  }

  void until(RoutePredicate predicate, {int? id}) =>
      _global(id).currentState?.popUntil(predicate);

  Future<T?>? offUntil<T>(Route<T> page, RoutePredicate predicate, {int? id}) =>
      _global(id).currentState?.pushAndRemoveUntil<T>(page, predicate);

  Future<T?>? offNamedUntil<T>(
    String page,
    RoutePredicate predicate, {
    int? id,
    Object? arguments,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final Uri uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return _global(id).currentState?.pushNamedAndRemoveUntil<T>(
          page,
          predicate,
          arguments: arguments,
        );
  }

  Future<T?>? offAndToNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    Object? result,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return _global(id).currentState?.popAndPushNamed(
          page,
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

  Route<DevEssentialRoute> nestedRoutes({
    required RouteSettings settings,
    required List<DevEssentialPage> pages,
    DevEssentialPage? unknownRoute,
  }) =>
      PagePredict(
        settings: settings,
        unknownRoute: unknownRoute ?? DevEssentialPages.defaultUnknownRoute,
      ).fromPages(pages);

  DevEssentialNavigationObserver get navigatorObserver =>
      DevEssentialNavigationObserver(routing: routing);

  Future<bool> handleNestedNavigationBackButton() async {
    return false;
  }
}
