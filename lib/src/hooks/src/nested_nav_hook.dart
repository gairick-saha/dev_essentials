part of '../hooks.dart';

class DevEssentialNestedNavigatorState {
  DevEssentialNestedNavigatorState({
    required this.initialRoute,
    required this.routeGenerator,
    required this.onGenerateInitialRoutes,
    required this.observers,
  });

  final String initialRoute;
  final RouteFactory? routeGenerator;
  final RouteListFactory onGenerateInitialRoutes;
  final List<NavigatorObserver> observers;
}

DevEssentialNestedNavigatorState useDevEssentialNestedNavHook({
  required String initialRoute,
  required String? parentRoute,
  required DevEssentialPage? unknownRoute,
}) =>
    use(_NestedNavHook(
      initialRoute: initialRoute,
      parentRoute: parentRoute,
      unknownRoute: unknownRoute,
    ));

class _NestedNavHook extends Hook<DevEssentialNestedNavigatorState> {
  const _NestedNavHook({
    required this.initialRoute,
    required this.parentRoute,
    required this.unknownRoute,
  });

  final String initialRoute;
  final String? parentRoute;
  final DevEssentialPage? unknownRoute;

  @override
  HookState<DevEssentialNestedNavigatorState,
          Hook<DevEssentialNestedNavigatorState>>
      createState() => _NestedNavHookState();
}

class _NestedNavHookState
    extends HookState<DevEssentialNestedNavigatorState, _NestedNavHook> {
  late DevEssentialNestedNavigatorState _nestedNavigatorState;
  late String _initialRoute;
  String? _parentRoute;

  @override
  void initHook() {
    _setInitialRoute();
    _nestedNavigatorState = DevEssentialNestedNavigatorState(
      initialRoute: _initialRoute,
      routeGenerator: (RouteSettings settings) =>
          Dev.routeGenerator(settings: settings, isNestedRouting: true),
      onGenerateInitialRoutes: (_, String initialRoute) =>
          Dev.initialRouteGenerator(initialRoute,
              unknownRoute:
                  hook.unknownRoute ?? DevEssentialPages.defaultUnknownRoute),
      observers: [Dev.navigatorObserver(isNestedRouting: true)],
    );
    updateState();
    super.initHook();
  }

  void _setInitialRoute() {
    _parentRoute = hook.parentRoute;
    _initialRoute = hook.initialRoute;
    if (_parentRoute != null) {
      if (_initialRoute.startsWith(_parentRoute!)) {
        _initialRoute =
            _parentRoute! + _initialRoute.replaceAll(_parentRoute!, '');
      } else {
        _initialRoute = _parentRoute! + _initialRoute;
      }
    }
  }

  void updateState() => setState(() {});

  @override
  DevEssentialNestedNavigatorState build(BuildContext context) =>
      _nestedNavigatorState;
}
