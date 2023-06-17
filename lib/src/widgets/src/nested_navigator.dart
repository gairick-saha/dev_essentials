part of '../widgets.dart';

class DevNestedNavigator extends StatefulWidget {
  const DevNestedNavigator({
    required this.navigatorKey,
    required this.initialRoute,
    required this.pages,
  }) : super(key: null);

  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;
  final List<DevEssentialPage> pages;

  @override
  State<DevNestedNavigator> createState() => _DevNestedNavigatorState();
}

class _DevNestedNavigatorState extends State<DevNestedNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      initialRoute: widget.initialRoute,
      onGenerateRoute: (RouteSettings settings) => Dev.nestedRoutes(
        settings: settings,
        pages: widget.pages,
      ),
      observers: [Dev.navigatorObserver],
      reportsRouteUpdateToEngine: true,
    );
  }
}
