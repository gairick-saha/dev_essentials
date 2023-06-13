part of '../navigation.dart';

class DevEssentialRoutingTree {
  DevEssentialRoutingTree({
    required this.routes,
  });

  final List<DevEssentialPage> routes;

  void addRoutes(List<DevEssentialPage> pages) => routes.addAll(pages);

  DevEssentialPage? matchRoute(String name, {Object? arguments}) {
    final Uri uri = Uri.parse(name);
    return routes.firstWhereOrNull((element) => element.name == uri.path);
  }

  DevEssentialPage? matchRouteFromListOfPages(
      List<DevEssentialPage> pages, String name,
      {Object? arguments}) {
    final Uri uri = Uri.parse(name);
    return pages.firstWhereOrNull((element) => element.name == uri.path);
  }
}
