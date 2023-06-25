part of '../navigation.dart';

class DevEssentialNavigationObserver extends NavigatorObserver {
  DevEssentialNavigationObserver({
    required this.routing,
    this.isNestedRouting = false,
  });

  final DevEssentialRouting routing;
  final bool isNestedRouting;

  @override
  void didPop(Route route, Route? previousRoute) {
    final _ObserverData currentRoute = _ObserverData.fromRoute(route);
    final _ObserverData newRoute = _ObserverData.fromRoute(previousRoute);

    if (currentRoute.isBottomSheet || currentRoute.isDialog) {
      Dev.print("CLOSE ${currentRoute.logText}");
    } else if (currentRoute.isDevEssentialRoute) {
      Dev.print(
        "CLOSED ROUTE ${currentRoute.logText}",
        name: isNestedRouting ? 'DevNestedNavigator' : null,
      );
    }

    routing.update((value) {
      if (newRoute.isDevEssentialRoute) {
        value.currentRoute = newRoute.name;
        value.previousRoute = newRoute.name;
      } else if ((value.previousRoute ?? '').isNotEmpty) {
        value.currentRoute = value.previousRoute;
      }

      value.arguments = newRoute.arguments;
      value.route = newRoute.route;
      value.isBack = true;
      value.isBottomSheet = newRoute.isBottomSheet;
      value.isDialog = newRoute.isDialog;
    });

    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    final _ObserverData newRoute = _ObserverData.fromRoute(route);
    final _ObserverData oldRoute = _ObserverData.fromRoute(previousRoute);

    if (newRoute.isBottomSheet || newRoute.isDialog) {
      Dev.print(
        "OPEN ${newRoute.logText}",
        name: isNestedRouting ? 'DevNestedNavigator' : null,
      );
    } else if (newRoute.isDevEssentialRoute) {
      Dev.print(
        "GOING TO ROUTE ${newRoute.logText}",
        name: isNestedRouting ? 'DevNestedNavigator' : null,
      );
    }

    routing.update((value) {
      if (newRoute.isDevEssentialRoute) {
        value.currentRoute = newRoute.name;
      }

      value.previousRoute = oldRoute.name;
      value.arguments = newRoute.arguments;
      value.route = newRoute.route;
      value.isBack = false;
      value.isBottomSheet =
          newRoute.isBottomSheet ? true : (value.isBottomSheet ?? false);
      value.isDialog = newRoute.isDialog ? true : (value.isDialog ?? false);
    });
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    final _ObserverData currentRoute = _ObserverData.fromRoute(route);

    if (currentRoute.isDevEssentialRoute) {
      Dev.print(
        "REMOVED ROUTE ${currentRoute.logText}",
        name: isNestedRouting ? 'DevNestedNavigator' : null,
      );
    }

    routing.update((value) {
      value.route = currentRoute.route;
      value.isBack = false;
      value.previousRoute = currentRoute.name;
      value.isBottomSheet =
          currentRoute.isBottomSheet ? false : value.isBottomSheet;
      value.isDialog = currentRoute.isDialog ? false : value.isDialog;
    });

    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final _ObserverData newRouteData = _ObserverData.fromRoute(newRoute);
    final _ObserverData oldRouteData = _ObserverData.fromRoute(oldRoute);

    if (oldRouteData.isDevEssentialRoute) {
      Dev.print(
        "REPLACE ROUTE ${oldRouteData.logText}",
        name: isNestedRouting ? 'DevNestedNavigator' : null,
      );
    }

    if (newRouteData.isDevEssentialRoute) {
      Dev.print(
        "NEW ROUTE ${newRouteData.logText}",
        name: isNestedRouting ? 'DevNestedNavigator' : null,
      );
    }

    routing.update((value) {
      if (newRouteData.isDevEssentialRoute) {
        value.currentRoute = newRouteData.name;
      }

      value.arguments = newRouteData.arguments;
      value.route = newRouteData.route;
      value.isBack = false;
      value.previousRoute = oldRouteData.name;
      value.isBottomSheet =
          newRouteData.isBottomSheet ? false : value.isBottomSheet;
      value.isDialog = newRouteData.isDialog ? false : value.isDialog;
    });

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
