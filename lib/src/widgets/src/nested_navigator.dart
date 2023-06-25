part of '../widgets.dart';

class DevNestedNavigator extends HookWidget {
  const DevNestedNavigator({
    required this.navigatorKey,
    required this.initialRoute,
    this.parentRoute,
    this.unknownRoute,
  }) : super(key: null);

  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;
  final String? parentRoute;
  final DevEssentialPage? unknownRoute;

  @override
  Widget build(BuildContext context) {
    DevEssentialNestedNavigatorState nestedNavigatorState =
        useDevEssentialNestedNavHook(
      initialRoute: initialRoute,
      parentRoute: parentRoute,
      unknownRoute: unknownRoute,
    );
    Dev.print(nestedNavigatorState.initialRoute);
    return Navigator(
      key: navigatorKey,
      initialRoute: nestedNavigatorState.initialRoute,
      onGenerateRoute: nestedNavigatorState.routeGenerator,
      onGenerateInitialRoutes: nestedNavigatorState.onGenerateInitialRoutes,
      observers: nestedNavigatorState.observers,
      reportsRouteUpdateToEngine: true,
    );
  }
}
