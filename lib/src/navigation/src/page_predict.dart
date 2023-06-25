part of '../navigation.dart';

class PagePredict {
  DevEssentialPage? route;
  DevEssentialPage? unknownRoute;
  RouteSettings? settings;
  bool isUnknown;

  PagePredict({
    this.route,
    this.unknownRoute,
    this.isUnknown = false,
    this.settings,
  });

  DevEssentialRoute<T> page<T>() {
    _checkRoute();
    final DevEssentialPage page = (isUnknown ? unknownRoute : route)!;
    return DevEssentialRoute<T>(
      settings: isUnknown
          ? RouteSettings(
              name: page.name,
              arguments: settings!.arguments,
            )
          : settings,
      pageBuilder: page.builder,
    );
  }

  List<DevEssentialRoute<T>> initialRouteName<T>() {
    _checkRoute();
    final DevEssentialPage page = (isUnknown ? unknownRoute : route)!;
    return [
      DevEssentialRoute<T>(
        settings: isUnknown
            ? RouteSettings(
                name: page.name,
                arguments: settings!.arguments,
              )
            : settings,
        pageBuilder: page.builder,
      ),
    ];
  }

  void _checkRoute() {
    if (settings == null && route != null) {
      settings = route;
    }

    final DevEssentialRouteDecoder matchedRoute = Dev.routingTree.matchRoute(
      settings!.name!,
      arguments: settings!.arguments,
    );

    if (matchedRoute.route == null) {
      isUnknown = true;
      return;
    }

    settings = RouteSettings(
      name: matchedRoute.name,
      arguments: matchedRoute.arguments,
    );
    route = matchedRoute.route;
    return;
  }
}
