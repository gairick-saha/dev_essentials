part of '../navigation.dart';

class DevEssentialRouterDelegate
    extends RouterDelegate<DevEssentialRouteDecoder>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<DevEssentialRouteDecoder>,
        DevEssentialNavigationInterface {
  DevEssentialRouterDelegate({
    DevEssentialPage? notFoundRoute,
    this.navigatorObservers,
    this.transitionDelegate,
    this.backButtonPopMode = PopMode.history,
    this.preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
    this.pickPagesForRootNavigator,
    this.restorationScopeId,
    bool showHashOnUrl = false,
    GlobalKey<NavigatorState>? navigatorKey,
    required List<DevEssentialPage> pages,
  })  : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        notFoundRoute =
            notFoundRoute ??= DevEssentialPages.defaultUnknownRoute {
    if (!showHashOnUrl && DevEssentialPlatform.isWeb) setUrlStrategy();
    addPages(pages);
    addPage(notFoundRoute);
    Dev.log(
        'DevEssentialRouterDelegate is created with navigator key $navigatorKey !');
  }

  factory DevEssentialRouterDelegate.createDelegate({
    DevEssentialPage<dynamic>? notFoundRoute,
    List<DevEssentialPage> pages = const [],
    List<NavigatorObserver>? navigatorObservers,
    TransitionDelegate<dynamic>? transitionDelegate,
    PopMode backButtonPopMode = PopMode.history,
    PreventDuplicateHandlingMode preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return DevEssentialRouterDelegate(
      notFoundRoute: notFoundRoute,
      navigatorObservers: navigatorObservers,
      transitionDelegate: transitionDelegate,
      backButtonPopMode: backButtonPopMode,
      preventDuplicateHandlingMode: preventDuplicateHandlingMode,
      pages: pages,
      navigatorKey: navigatorKey,
    );
  }

  final List<DevEssentialRouteDecoder> _activePages =
      <DevEssentialRouteDecoder>[];
  final PopMode backButtonPopMode;
  final PreventDuplicateHandlingMode preventDuplicateHandlingMode;

  final DevEssentialPage notFoundRoute;

  final List<NavigatorObserver>? navigatorObservers;
  final TransitionDelegate<dynamic>? transitionDelegate;

  final Iterable<DevEssentialPage> Function(
      DevEssentialRouteDecoder currentNavStack)? pickPagesForRootNavigator;

  List<DevEssentialRouteDecoder> get activePages => _activePages;

  final _routeTree = ParseRouteTree(routes: []);

  List<DevEssentialPage> get registeredRoutes => _routeTree.routes;

  @override
  GlobalKey<NavigatorState> navigatorKey;

  final String? restorationScopeId;

  void addPages(List<DevEssentialPage> pages) {
    _routeTree.addRoutes(pages);
  }

  void clearRouteTree() {
    _routeTree.routes.clear();
  }

  void addPage(DevEssentialPage pages) {
    _routeTree.addRoute(pages);
  }

  void removePage(DevEssentialPage pages) {
    _routeTree.removeRoute(pages);
  }

  DevEssentialRouteDecoder matchRoute(String name,
      {DevEssentialPageSettings? arguments}) {
    return _routeTree.matchRoute(name, arguments: arguments);
  }

  Future<DevEssentialRouteDecoder?> runMiddleware(
      DevEssentialRouteDecoder config) async {
    final middlewares = config.currentTreeBranch.last.middlewares;
    if (middlewares.isEmpty) {
      return config;
    }
    var iterator = config;
    for (var item in middlewares) {
      var redirectRes = await item.redirectDelegate(iterator);
      if (redirectRes == null) return null;
      iterator = redirectRes;

      if (config != redirectRes) {
        break;
      }
    }

    if (iterator != config) {
      return await runMiddleware(iterator);
    }
    return iterator;
  }

  Future<void> _unsafeHistoryAdd(DevEssentialRouteDecoder config) async {
    final res = await runMiddleware(config);
    if (res == null) return;
    _activePages.add(res);
  }

  Future<T?> _unsafeHistoryRemoveAt<T>(int index, T result) async {
    if (index == _activePages.length - 1 && _activePages.length > 1) {
      final toCheck = _activePages[_activePages.length - 2];
      final resMiddleware = await runMiddleware(toCheck);
      if (resMiddleware == null) return null;
      _activePages[_activePages.length - 2] = resMiddleware;
    }

    final completer = _activePages.removeAt(index).route?.completer;
    if (completer?.isCompleted == false) completer!.complete(result);

    return completer?.future as T?;
  }

  T arguments<T>() => currentConfiguration?.pageSettings?.arguments as T;

  Map<String, String> get parameters =>
      currentConfiguration?.pageSettings?.params ?? {};

  DevEssentialPageSettings? get pageSettings =>
      currentConfiguration?.pageSettings;

  Future<void> _pushHistory(DevEssentialRouteDecoder config) async {
    if (config.route!.preventDuplicates) {
      final originalEntryIndex = _activePages.indexWhere(
          (element) => element.pageSettings?.name == config.pageSettings?.name);
      if (originalEntryIndex >= 0) {
        switch (preventDuplicateHandlingMode) {
          case PreventDuplicateHandlingMode.popUntilOriginalRoute:
            popModeUntil(config.pageSettings!.name, popMode: PopMode.page);
            break;
          case PreventDuplicateHandlingMode.reorderRoutes:
            await _unsafeHistoryRemoveAt(originalEntryIndex, null);
            await _unsafeHistoryAdd(config);
            break;
          case PreventDuplicateHandlingMode.doNothing:
          default:
            break;
        }
        return;
      }
    }
    await _unsafeHistoryAdd(config);
  }

  Future<T?> _popHistory<T>(T result) async {
    if (!_canPopHistory()) return null;
    return await _doPopHistory(result);
  }

  Future<T?> _doPopHistory<T>(T result) async =>
      await _unsafeHistoryRemoveAt<T>(_activePages.length - 1, result);

  Future<T?> _popPage<T>(T result) async {
    if (!_canPopPage()) return null;
    return await _doPopPage(result);
  }

  Future<T?> _doPopPage<T>(T result) async {
    final currentBranch = currentConfiguration?.currentTreeBranch;
    if (currentBranch != null && currentBranch.length > 1) {
      final remaining = currentBranch.take(currentBranch.length - 1);
      final prevHistoryEntry = _activePages.length > 1
          ? _activePages[_activePages.length - 2]
          : null;

      if (prevHistoryEntry != null) {
        final newLocation = remaining.last.name;
        final prevLocation = prevHistoryEntry.pageSettings?.name;
        if (newLocation == prevLocation) {
          return await _popHistory(result);
        }
      }

      final res = await _popHistory<T>(result);
      await _pushHistory(
        DevEssentialRouteDecoder(
          remaining.toList(),
          null,
        ),
      );
      return res;
    } else {
      return await _popHistory(result);
    }
  }

  Future<T?> _pop<T>(PopMode mode, T result) async {
    switch (mode) {
      case PopMode.history:
        return await _popHistory<T>(result);
      case PopMode.page:
        return await _popPage<T>(result);
      default:
        return null;
    }
  }

  Future<T?> popHistory<T>(T result) async => await _popHistory<T>(result);

  bool _canPopHistory() => _activePages.length > 1;

  Future<bool> canPopHistory() => SynchronousFuture(_canPopHistory());

  bool _canPopPage() {
    final currentTreeBranch = currentConfiguration?.currentTreeBranch;
    if (currentTreeBranch == null) return false;
    return currentTreeBranch.length > 1 ? true : _canPopHistory();
  }

  Future<bool> canPopPage() => SynchronousFuture(_canPopPage());

  bool _canPop(mode) {
    switch (mode) {
      case PopMode.history:
        return _canPopHistory();
      case PopMode.page:
      default:
        return _canPopPage();
    }
  }

  Iterable<DevEssentialPage> getVisualPages(
    DevEssentialRouteDecoder? currentHistory,
  ) {
    final res = currentHistory!.currentTreeBranch
        .where((r) => r.participatesInRootNavigator != null);
    if (res.isEmpty) {
      return _activePages.map((e) => e.route!);
    } else {
      return res
          .where((element) => element.participatesInRootNavigator == true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHistory = currentConfiguration;
    final pages = currentHistory == null
        ? <DevEssentialPage>[]
        : pickPagesForRootNavigator?.call(currentHistory).toList() ??
            getVisualPages(currentHistory).toList();
    if (pages.isEmpty) {
      return ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
      );
    }

    return DevEssentialNavigator(
      key: navigatorKey,
      onPopPage: _onPopVisualRoute,
      pages: pages,
      observers: navigatorObservers,
      transitionDelegate:
          transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
    );
  }

  DevEssentialPageRoutePredicate withName(String name) {
    return (DevEssentialPage<dynamic> page) {
      return page is ModalRoute && page.name == name;
    };
  }

  @override
  Future<void> goToUnknownPage([bool clearPages = false]) async {
    if (clearPages) _activePages.clear();

    final pageSettings = _buildPageSettings(notFoundRoute.name);
    final routeDecoder = _getRouteDecoder(pageSettings);

    _push(routeDecoder!);
  }

  @protected
  void _popWithResult<T>([T? result]) {
    final completer = _activePages.removeLast().route?.completer;
    if (completer?.isCompleted == false) completer!.complete(result);
  }

  @override
  Future<T?> toNamed<T>(
    String page, {
    dynamic arguments,
    String? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(page, arguments);
    final route = _getRouteDecoder<T>(args);
    if (route != null) {
      return _push<T>(route);
    } else {
      goToUnknownPage();
    }
    return null;
  }

  @override
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
    bool rebuildStack = true,
    PreventDuplicateHandlingMode preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
  }) async {
    routeName = _cleanRouteName("/${page.runtimeType}");

    final getPage = DevEssentialPage<T>(
      name: routeName,
      opaque: opaque ?? true,
      page: page,
      gestureWidth: gestureWidth,
      showCupertinoParallax: showCupertinoParallax,
      popGesture: popGesture ?? Dev.defaultPopGesture,
      transition: transition ?? Dev.defaultTransition,
      curve: curve ?? Dev.defaultTransitionCurve,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: duration ?? Dev.defaultTransitionDuration,
      preventDuplicateHandlingMode: preventDuplicateHandlingMode,
    );

    _routeTree.addRoute(getPage);
    final args = _buildPageSettings(routeName, arguments);
    final route = _getRouteDecoder<T>(args);
    final result = await _push<T>(
      route!,
      rebuildStack: rebuildStack,
    );
    _routeTree.removeRoute(getPage);
    return result;
  }

  @override
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
  }) async {
    routeName = _cleanRouteName("/${page.runtimeType}");
    final route = DevEssentialPage<T>(
      name: routeName,
      opaque: opaque ?? true,
      page: page,
      gestureWidth: gestureWidth,
      showCupertinoParallax: showCupertinoParallax,
      popGesture: popGesture ?? Dev.defaultPopGesture,
      transition: transition ?? Dev.defaultTransition,
      curve: curve ?? Dev.defaultTransitionCurve,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: duration ?? Dev.defaultTransitionDuration,
    );

    final args = _buildPageSettings(routeName, arguments);
    return _replace(args, route);
  }

  @override
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
  }) async {
    routeName = _cleanRouteName("/${page.runtimeType}");
    final route = DevEssentialPage<T>(
      name: routeName,
      opaque: opaque,
      page: page,
      gestureWidth: gestureWidth,
      showCupertinoParallax: showCupertinoParallax,
      popGesture: popGesture ?? Dev.defaultPopGesture,
      transition: transition ?? Dev.defaultTransition,
      curve: curve ?? Dev.defaultTransitionCurve,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: duration ?? Dev.defaultTransitionDuration,
    );

    final args = _buildPageSettings(routeName, arguments);

    final newPredicate = predicate ?? (route) => false;

    while (_activePages.length > 1 && !newPredicate(_activePages.last.route!)) {
      _popWithResult();
    }

    return _replace(args, route);
  }

  @override
  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(newRouteName, arguments);
    final route = _getRouteDecoder<T>(args);
    if (route == null) return null;

    while (_activePages.length > 1) {
      _activePages.removeLast();
    }

    return _replaceNamed(route);
  }

  @override
  Future<T?>? offNamedUntil<T>(
    String page, {
    DevEssentialPageRoutePredicate? predicate,
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(page, arguments);
    final route = _getRouteDecoder<T>(args);
    if (route == null) return null;

    final newPredicate = predicate ?? (route) => false;

    while (_activePages.length > 1 && newPredicate(_activePages.last.route!)) {
      _activePages.removeLast();
    }

    return _replaceNamed(route);
  }

  @override
  Future<T?> offNamed<T>(
    String page, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(page, arguments);
    final route = _getRouteDecoder<T>(args);
    if (route == null) return null;
    _popWithResult();
    return _push<T>(route);
  }

  @override
  Future<T?> toNamedAndOffUntil<T>(
    String page,
    DevEssentialPageRoutePredicate predicate, [
    Object? data,
  ]) async {
    final arguments = _buildPageSettings(page, data);

    final route = _getRouteDecoder<T>(arguments);

    if (route == null) return null;

    while (_activePages.isNotEmpty && !predicate(_activePages.last.route!)) {
      _popWithResult();
    }

    return _push<T>(route);
  }

  @override
  Future<T?> offUntil<T>(
    DevEssentialPageBuilder page,
    DevEssentialPageRoutePredicate predicate, [
    Object? arguments,
  ]) async {
    while (_activePages.isNotEmpty && !predicate(_activePages.last.route!)) {
      _popWithResult();
    }

    return to<T>(page, arguments: arguments);
  }

  @override
  void removeRoute<T>(String name) {
    _activePages.remove(DevEssentialRouteDecoder.fromRoute(name));
  }

  bool get canBack {
    return _activePages.length > 1;
  }

  void _checkIfCanBack() {
    assert(() {
      if (!canBack) {
        final last = _activePages.last;
        final name = last.route?.name;
        throw 'The page $name cannot be popped';
      }
      return true;
    }());
  }

  @override
  Future<R?> backAndtoNamed<T, R>(String page,
      {T? result, Object? arguments}) async {
    final args = _buildPageSettings(page, arguments);
    final route = _getRouteDecoder<R>(args);
    if (route == null) return null;
    _popWithResult<T>(result);
    return _push<R>(route);
  }

  @override
  Future<void> popModeUntil(
    String fullRoute, {
    PopMode popMode = PopMode.history,
  }) async {
    var iterator = currentConfiguration;
    while (_canPop(popMode) &&
        iterator != null &&
        iterator.pageSettings?.name != fullRoute) {
      await _pop(popMode, null);

      iterator = currentConfiguration;
    }
    notifyListeners();
  }

  @override
  void backUntil(bool Function(DevEssentialPage) predicate) {
    while (_activePages.length <= 1 && !predicate(_activePages.last.route!)) {
      _popWithResult();
    }

    notifyListeners();
  }

  Future<T?> _replace<T>(
    DevEssentialPageSettings arguments,
    DevEssentialPage<T> page,
  ) async {
    final index = _activePages.length > 1 ? _activePages.length - 1 : 0;
    _routeTree.addRoute(page);

    final activePage = _getRouteDecoder(arguments);

    _activePages[index] = activePage!;

    notifyListeners();
    final result = await activePage.route?.completer?.future as Future<T?>?;
    _routeTree.removeRoute(page);

    return result;
  }

  Future<T?> _replaceNamed<T>(DevEssentialRouteDecoder activePage) async {
    final index = _activePages.length > 1 ? _activePages.length - 1 : 0;

    _activePages[index] = activePage;

    notifyListeners();
    final result = await activePage.route?.completer?.future as Future<T?>?;
    return result;
  }

  String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }

  DevEssentialPageSettings _buildPageSettings(String page, [Object? data]) =>
      DevEssentialPageSettings(Uri.parse(page), data);

  @protected
  DevEssentialRouteDecoder? _getRouteDecoder<T>(
      DevEssentialPageSettings arguments) {
    var page = arguments.uri.path;
    final parameters = arguments.params;
    if (parameters.isNotEmpty) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    final decoder = _routeTree.matchRoute(page, arguments: arguments);
    final route = decoder.route;
    if (route == null) return null;

    return _configureRouterDecoder<T>(decoder, arguments);
  }

  @protected
  DevEssentialRouteDecoder _configureRouterDecoder<T>(
    DevEssentialRouteDecoder decoder,
    DevEssentialPageSettings arguments,
  ) {
    final parameters =
        arguments.params.isEmpty ? arguments.query : arguments.params;
    arguments.params.addAll(arguments.query);
    if (decoder.parameters.isEmpty) {
      decoder.parameters.addAll(parameters);
    }

    decoder.route = decoder.route?.copyWith(
      completer: _activePages.isEmpty ? null : Completer<T?>(),
      arguments: arguments.arguments,
      parameters: parameters,
      key: ValueKey(arguments.name),
    );

    return decoder;
  }

  Future<T?> _push<T>(DevEssentialRouteDecoder decoder,
      {bool rebuildStack = true}) async {
    var mid = await runMiddleware(decoder);
    final res = mid ?? decoder;

    final preventDuplicateHandlingMode =
        res.route?.preventDuplicateHandlingMode ??
            PreventDuplicateHandlingMode.reorderRoutes;

    final onStackPage = _activePages
        .firstWhereOrNull((element) => element.route?.key == res.route?.key);

    if (onStackPage == null) {
      _activePages.add(res);
    } else {
      switch (preventDuplicateHandlingMode) {
        case PreventDuplicateHandlingMode.doNothing:
          break;
        case PreventDuplicateHandlingMode.reorderRoutes:
          _activePages.remove(onStackPage);
          _activePages.add(res);
          break;
        case PreventDuplicateHandlingMode.popUntilOriginalRoute:
          while (_activePages.last == onStackPage) {
            _popWithResult();
          }
          break;
        case PreventDuplicateHandlingMode.recreate:
          _activePages.remove(onStackPage);
          _activePages.add(res);
          break;
        default:
      }
    }
    if (rebuildStack) {
      notifyListeners();
    }

    return decoder.route?.completer?.future as Future<T?>?;
  }

  @override
  Future<void> setNewRoutePath(DevEssentialRouteDecoder configuration) async {
    final page = configuration.route;
    if (page == null) {
      goToUnknownPage();
      return;
    } else {
      _push(configuration);
    }
  }

  @override
  DevEssentialRouteDecoder? get currentConfiguration {
    if (_activePages.isEmpty) return null;
    final route = _activePages.last;
    return route;
  }

  Future<bool> handlePopupRoutes({
    Object? result,
  }) async {
    Route? currentRoute;
    navigatorKey.currentState!.popUntil((route) {
      currentRoute = route;
      return true;
    });
    if (currentRoute is PopupRoute) {
      return await navigatorKey.currentState!.maybePop(result);
    }
    return false;
  }

  @override
  Future<bool> popRoute({
    Object? result,
    PopMode? popMode,
  }) async {
    final wasPopup = await handlePopupRoutes(result: result);
    if (wasPopup) return true;

    if (_canPop(popMode ?? backButtonPopMode)) {
      await _pop(popMode ?? backButtonPopMode, result);
      notifyListeners();
      return true;
    }

    return super.popRoute();
  }

  @override
  void back<T>([T? result]) {
    _checkIfCanBack();
    _popWithResult<T>(result);
    notifyListeners();
  }

  bool _onPopVisualRoute(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    _popWithResult(result);

    notifyListeners();

    return true;
  }
}
