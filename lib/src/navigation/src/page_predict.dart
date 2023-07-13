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
      name: isUnknown ? settings!.name! : page.name!,
      arguments: isUnknown ? settings!.name! : page.arguments,
      parameters: Dev.routingTree._parseParams(page.name!, page.path),
      pageBuilder: (context) => page.builder(context, settings!.arguments),
    );
  }

  List<DevEssentialRoute<T>> initialRouteName<T>() {
    _checkRoute();
    final DevEssentialPage page = (isUnknown ? unknownRoute : route)!;
    return [
      DevEssentialRoute<T>(
        name: isUnknown ? settings!.name! : page.name!,
        arguments: isUnknown ? settings!.name! : page.arguments,
        parameters: Dev.routingTree._parseParams(page.name!, page.path),
        pageBuilder: (context) => page.builder(context, settings!.arguments),
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
    DevEssentialHookState.instance.parameters = matchedRoute.parameters;

    if (matchedRoute.route == null) {
      isUnknown = true;
      return;
    }

    addPageParameter(matchedRoute.route!);

    settings = RouteSettings(
      name: matchedRoute.name,
      arguments: matchedRoute.arguments,
    );
    route = matchedRoute.route;
    return;
  }

  void addPageParameter(DevEssentialPage route) {
    if (route.parameters == null) return;

    final Map<String, String> parameters =
        DevEssentialHookState.instance.parameters;
    parameters.addEntries(route.parameters!.entries);
    DevEssentialHookState.instance.parameters = parameters;
  }
}
