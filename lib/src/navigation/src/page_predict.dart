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

  DevEssentialRoute<T> fromPages<T>(List<DevEssentialPage> pages) {
    _checkRoute(pages: pages);
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

  void _checkRoute({List<DevEssentialPage>? pages}) {
    if (settings == null && route != null) {
      settings = route;
    }

    final DevEssentialPage? matchedRoute;

    if (pages != null) {
      matchedRoute = Dev.routing.routingTree.matchRouteFromListOfPages(
        pages,
        settings!.name!,
        arguments: settings!.arguments,
      );
    } else {
      matchedRoute = Dev.routing.routingTree.matchRoute(
        settings!.name!,
        arguments: settings!.arguments,
      );
    }

    if (matchedRoute == null) {
      isUnknown = true;
      return;
    }

    settings = RouteSettings(
      name: matchedRoute.name,
      arguments: matchedRoute.arguments,
    );
    route = matchedRoute;
    return;
  }
}
