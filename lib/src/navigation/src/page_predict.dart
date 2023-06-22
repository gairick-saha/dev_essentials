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

  DevEssentialRoute<T> page<T>({
    bool isNestedRouting = false,
    String? initialNestedRoute,
  }) {
    _checkRoute(isNestedRouting, initialNestedRoute: initialNestedRoute);
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

  void _checkRoute(bool isNestedRouting, {String? initialNestedRoute}) {
    if (settings == null && route != null) {
      settings = route;
    }

    final DevEssentialPage? matchedRoute = isNestedRouting
        ? Dev.nestedRoutingTree.matchRoute(
            settings!.name!,
            arguments: settings!.arguments,
            initialNestedRoute: initialNestedRoute,
          )
        : Dev.routingTree.matchRoute(
            settings!.name!,
            arguments: settings!.arguments,
          );

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
