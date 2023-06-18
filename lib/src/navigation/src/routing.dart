part of '../navigation.dart';

class DevEssentialRouting {
  DevEssentialRouting();

  final DevEssentialRoutingTree routingTree = DevEssentialRoutingTree(
    routes: [],
  );

  void clearPages() => routingTree.clearRoutingTree();

  void addPages(List<DevEssentialPage> pages) => routingTree.addRoutes(pages);

  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  final Map<int, GlobalKey<NavigatorState>> nestedNavigatorKeys = {};

  String? _currentRoute, _previousRoute;

  String? get currentRoute => _currentRoute;

  String? get previousRoute => _previousRoute;

  void updateCurrentRoute(String? route) => _currentRoute = route;

  void updatePreviousRoute(String? route) => _previousRoute = route;
}
