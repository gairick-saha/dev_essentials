part of '../../navigation.dart';

class DevEssentialNavigationObserver extends NavigatorObserver {
  final Function(DevEssentialRouting? routing)? routing;

  final DevEssentialRouting? _routeSend;

  DevEssentialNavigationObserver([this.routing, this._routeSend]);

  @override
  void didPop(Route route, Route? previousRoute) {
    final currentRoute = _DevEssentialRoutingData.ofRoute(route);
    final newRoute = _DevEssentialRoutingData.ofRoute(previousRoute);

    if (currentRoute.isBottomSheet || currentRoute.isDialog) {
      Dev.log("CLOSE ${currentRoute.name}");
    } else if (currentRoute.isDevEssentialPageRoute) {
      Dev.log("CLOSE TO ROUTE ${currentRoute.name}");
    }

    _routeSend?.update((value) {
      if (previousRoute is PageRoute) {
        value.current = _extractRouteName(previousRoute) ?? '';
        value.previous = newRoute.name ?? '';
      } else if ((value.previous ?? '').isNotEmpty) {
        value.current = value.previous;
      }

      value.arguments = previousRoute?.settings.arguments;
      value.route = previousRoute;
      value.isBack = true;
      value.isBottomSheet = newRoute.isBottomSheet;
      value.isDialog = newRoute.isDialog;
    });

    routing?.call(_routeSend);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    final newRoute = _DevEssentialRoutingData.ofRoute(route);

    if (newRoute.isBottomSheet || newRoute.isDialog) {
      Dev.log("OPEN ${newRoute.name}");
    } else if (newRoute.isDevEssentialPageRoute) {
      Dev.log("GOING TO ROUTE ${newRoute.name}");
    }

    _routeSend!.update((value) {
      if (route is PageRoute) {
        value.current = newRoute.name ?? '';
      }
      final previousRouteName = _extractRouteName(previousRoute);
      if (previousRouteName != null) {
        value.previous = previousRouteName;
      }

      value.arguments = route.settings.arguments;
      value.route = route;
      value.isBack = false;
      value.isBottomSheet = newRoute.isBottomSheet ? true : value.isBottomSheet;
      value.isDialog = newRoute.isDialog ? true : value.isDialog;
    });

    routing?.call(_routeSend);
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    final routeName = _extractRouteName(route);
    final currentRoute = _DevEssentialRoutingData.ofRoute(route);

    Dev.log("REMOVING ROUTE $routeName");

    _routeSend?.update((value) {
      value.route = previousRoute;
      value.isBack = false;
      value.previous = routeName ?? '';

      value.isBottomSheet =
          currentRoute.isBottomSheet ? false : value.isBottomSheet;
      value.isDialog = currentRoute.isDialog ? false : value.isDialog;
    });

    routing?.call(_routeSend);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final newName = _extractRouteName(newRoute);
    final oldName = _extractRouteName(oldRoute);
    final currentRoute = _DevEssentialRoutingData.ofRoute(oldRoute);

    Dev.log("REPLACE ROUTE $oldName");
    Dev.log("NEW ROUTE $newName");

    _routeSend?.update((value) {
      if (newRoute is PageRoute) {
        value.current = newName ?? '';
      }

      value.arguments = newRoute?.settings.arguments;
      value.route = newRoute;
      value.isBack = false;
      value.previous = '$oldName';

      value.isBottomSheet =
          currentRoute.isBottomSheet ? false : value.isBottomSheet;
      value.isDialog = currentRoute.isDialog ? false : value.isDialog;
    });

    routing?.call(_routeSend);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
