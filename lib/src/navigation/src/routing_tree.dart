part of '../navigation.dart';

class DevEssentialRoutingTree {
  DevEssentialRoutingTree({
    required this.routes,
  });

  final List<DevEssentialPage> routes;

  void clearRoutingTree() => routes.clear();

  void addRoutes(List<DevEssentialPage> pages) => routes.addAll(pages);

  DevEssentialPage? matchRoute(
    String name, {
    Object? arguments,
    String? initialNestedRoute,
  }) {
    final Uri uri = Uri.parse(name);
    return routes.firstWhereOrNull((element) => element.name == uri.path);
  }
}


// final DevEssentialRoutingTree routingTree = DevEssentialRoutingTree(
//   routes: [],
// );

// void clearPages() => routingTree.clearRoutingTree();

// void addPages(List<DevEssentialPage> pages) => routingTree.addRoutes(pages);

// final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// final Map<int, GlobalKey<NavigatorState>> nestedNavigatorKeys = {};
