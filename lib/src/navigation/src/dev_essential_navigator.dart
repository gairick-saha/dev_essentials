part of '../navigation.dart';

class InheritedNavigator extends InheritedWidget {
  const InheritedNavigator({
    super.key,
    required super.child,
    required this.navigatorKey,
  });
  final GlobalKey<NavigatorState> navigatorKey;

  static InheritedNavigator? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedNavigator>();
  }

  @override
  bool updateShouldNotify(InheritedNavigator oldWidget) => true;
}

class DevEssentialNavigator extends Navigator {
  DevEssentialNavigator({
    Key? key,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    required List<DevEssentialPage> pages,
    List<NavigatorObserver>? observers,
    bool reportsRouteUpdateToEngine = false,
    TransitionDelegate? transitionDelegate,
    String? initialRoute,
    String? restorationScopeId,
  }) : super(
          key: key,
          initialRoute: initialRoute,
          onPopPage: onPopPage ??
              (route, result) {
                final didPop = route.didPop(result);
                if (!didPop) {
                  return false;
                }
                return true;
              },
          reportsRouteUpdateToEngine: reportsRouteUpdateToEngine,
          restorationScopeId: restorationScopeId,
          pages: pages,
          observers: [
            HeroController(),
            ...?observers,
          ],
          transitionDelegate:
              transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );
}
