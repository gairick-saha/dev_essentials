part of '../navigation.dart';

String? _extractRouteName(Route? route) {
  if (route is DevEssentialRoute) {
    return route.settings.name;
  } else if (route?.settings.name != null) {
    return route!.settings.name;
  }

  return null;
}

class DevEssentialNavigationObserver extends NavigatorObserver {
  DevEssentialNavigationObserver({
    required this.routing,
    this.isNestedRouting = false,
  });

  final DevEssentialRouting routing;
  final bool isNestedRouting;

  @override
  void didPush(Route route, Route? previousRoute) {
    final String? newName = _extractRouteName(route);
    final String? oldName = _extractRouteName(previousRoute);

    Dev.print(
      "GOING TO ROUTE $newName",
      name: isNestedRouting ? 'DevNestedNavigator' : null,
    );

    routing.updateCurrentRoute(newName);
    routing.updatePreviousRoute(oldName);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final String? newName = _extractRouteName(newRoute);
    final String? oldName = _extractRouteName(oldRoute);

    Dev.print(
      "REPLACE ROUTE $oldName",
      name: isNestedRouting ? 'DevNestedNavigator' : null,
    );
    Dev.print(
      "NEW ROUTE $newName",
      name: isNestedRouting ? 'DevNestedNavigator' : null,
    );

    routing.updateCurrentRoute(newName);
    routing.updatePreviousRoute(oldName);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final String? currentRoute = _extractRouteName(route);
    final String? newRoute = _extractRouteName(previousRoute);

    Dev.print(
      "CLOSED ROUTE $currentRoute",
      name: isNestedRouting ? 'DevNestedNavigator' : null,
    );

    if (previousRoute is PageRoute) {
      routing.updateCurrentRoute(_extractRouteName(previousRoute) ?? '');
      routing.updatePreviousRoute(newRoute);
    } else if ((routing.previousRoute ?? '').isNotEmpty) {
      routing.updateCurrentRoute(routing.previousRoute);
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    final String? currentRoute = _extractRouteName(route);

    Dev.print(
      "REMOVED ROUTE $currentRoute",
      name: isNestedRouting ? 'DevNestedNavigator' : null,
    );

    routing.updateCurrentRoute(previousRoute?.settings.name);
    routing.updatePreviousRoute(route.settings.name);
    super.didRemove(route, previousRoute);
  }
}
