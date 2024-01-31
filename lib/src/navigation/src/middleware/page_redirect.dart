part of '../../navigation.dart';

class PageRedirect {
  PageRedirect({
    this.route,
    this.unknownRoute,
    this.isUnknown = false,
    this.settings,
  });

  DevEssentialPage? route;
  DevEssentialPage? unknownRoute;
  RouteSettings? settings;
  bool isUnknown;

  DevEssentialPageRoute<T> getPageToRoute<T>(
    DevEssentialPage route,
    DevEssentialPage? unknown,
    BuildContext context,
  ) {
    while (needRecheck(context)) {}
    final r = (isUnknown ? unknown : route)!;

    return DevEssentialPageRoute<T>(
      page: r.page,
      parameter: r.parameters,
      alignment: r.alignment,
      title: r.title,
      maintainState: r.maintainState,
      settings: r,
      name: r.name,
      arguments: r.arguments,
      curve: r.curve,
      showCupertinoParallax: r.showCupertinoParallax,
      gestureWidth: r.gestureWidth,
      opaque: r.opaque,
      customTransition: r.customTransition,
      transitionDuration: r.transitionDuration ?? Dev.defaultTransitionDuration,
      reverseTransitionDuration:
          r.reverseTransitionDuration ?? Dev.defaultTransitionDuration,
      transition: r.transition,
      popGesture: r.popGesture,
      fullscreenDialog: r.fullscreenDialog,
      middlewares: r.middlewares,
    );
  }

  bool needRecheck(BuildContext context) {
    if (settings == null && route != null) {
      settings = route;
    }
    final match =
        DevEssentialHookState.instance.rootDelegate.matchRoute(settings!.name!);
    Dev.parameters = match.parameters;

    if (match.route == null) {
      isUnknown = true;
      return false;
    }

    final runner = _MiddlewareRunner(match.route!.middlewares);
    route = runner.runOnPageCalled(match.route);
    addPageParameter(route!);

    if (match.route!.middlewares.isEmpty) {
      return false;
    }
    final newSettings = runner.runRedirect(settings!.name);
    if (newSettings == null) {
      return false;
    }
    settings = newSettings;
    return true;
  }

  void addPageParameter(DevEssentialPage route) {
    if (route.parameters == null) return;

    final parameters = Map<String, String?>.from(Dev.parameters);
    parameters.addEntries(route.parameters!.entries);
  }
}
