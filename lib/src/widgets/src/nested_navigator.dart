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
  List<DevEssentialPage> pages = [];

  @override
  void initState() {
    _setPages();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DevNestedNavigator oldWidget) {
    if (oldWidget.pages.length != widget.pages.length) {
      _setPages();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setPages() {
    pages = widget.pages;
    Dev.nestedRouting.clearPages();
    Dev.nestedRouting.addPages(pages);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      initialRoute: widget.initialRoute,
      onGenerateRoute: (RouteSettings settings) => Dev.onGenerateRoute(
        settings: settings,
        isNestedRouting: true,
      ),
      onGenerateInitialRoutes: (navigator, initialRoute) =>
          Dev.initialRoutesGenerate(
        initialRoute,
        isNestedRouting: true,
      ),
      observers: [
        Dev.navigatorObserver(isNestedRouting: true),
      ],
      reportsRouteUpdateToEngine: true,
    );
  }
}
