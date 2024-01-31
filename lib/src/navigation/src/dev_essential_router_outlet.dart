part of '../navigation.dart';

class _RouterOutlet<TDelegate extends RouterDelegate<T>, T extends Object>
    extends StatefulWidget {
  final TDelegate routerDelegate;
  final Widget Function(BuildContext context) builder;

  _RouterOutlet.builder({
    super.key,
    TDelegate? delegate,
    required this.builder,
  }) : routerDelegate = delegate ?? Dev.delegate<TDelegate, T>()!;

  _RouterOutlet({
    Key? key,
    TDelegate? delegate,
    required Iterable<DevEssentialPage> Function(T currentNavStack) pickPages,
    required Widget Function(
      BuildContext context,
      TDelegate,
      Iterable<DevEssentialPage>? page,
    ) pageBuilder,
  }) : this.builder(
            builder: (context) {
              final currentConfig = context.delegate.currentConfiguration as T?;
              final rDelegate = context.delegate as TDelegate;
              var picked =
                  currentConfig == null ? null : pickPages(currentConfig);
              if (picked?.isEmpty ?? true) {
                picked = null;
              }
              return pageBuilder(context, rDelegate, picked);
            },
            delegate: delegate,
            key: key);
  @override
  _RouterOutletState<TDelegate, T> createState() =>
      _RouterOutletState<TDelegate, T>();
}

class _RouterOutletState<TDelegate extends RouterDelegate<T>, T extends Object>
    extends State<_RouterOutlet<TDelegate, T>> {
  RouterDelegate? delegate;
  late ChildBackButtonDispatcher _backButtonDispatcher;

  void _listener() {
    setState(() {});
  }

  VoidCallback? disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    disposer?.call();
    final router = Router.of(context);
    delegate ??= router.routerDelegate;
    delegate?.addListener(_listener);
    disposer = () => delegate?.removeListener(_listener);

    _backButtonDispatcher =
        router.backButtonDispatcher!.createChildBackButtonDispatcher();
  }

  @override
  void dispose() {
    super.dispose();
    disposer?.call();
  }

  @override
  Widget build(BuildContext context) {
    _backButtonDispatcher.takePriority();
    return widget.builder(context);
  }
}

class DevEssentialRouterOutlet extends _RouterOutlet<DevEssentialRouterDelegate,
    DevEssentialRouteDecoder> {
  DevEssentialRouterOutlet({
    Key? key,
    String? anchorRoute,
    required String initialRoute,
    Iterable<DevEssentialPage> Function(Iterable<DevEssentialPage> afterAnchor)?
        filterPages,
    DevEssentialRouterDelegate? delegate,
    String? restorationScopeId,
  }) : this.pickPages(
          restorationScopeId: restorationScopeId,
          pickPages: (config) {
            Iterable<DevEssentialPage<dynamic>> ret;
            if (anchorRoute == null) {
              // jump the ancestor path
              final length = Uri.parse(initialRoute).pathSegments.length;

              return config.currentTreeBranch
                  .skip(length)
                  .take(length)
                  .toList();
            }
            ret = config.currentTreeBranch.pickAfterRoute(anchorRoute);
            if (filterPages != null) {
              ret = filterPages(ret);
            }
            return ret;
          },
          key: key,
          emptyPage: (delegate) =>
              delegate.matchRoute(initialRoute).route ?? delegate.notFoundRoute,
          navigatorKey: Dev.nestedKey(anchorRoute)?.navigatorKey,
          delegate: delegate,
        );

  DevEssentialRouterOutlet.pickPages({
    super.key,
    Widget Function(DevEssentialRouterDelegate delegate)? emptyWidget,
    DevEssentialPage Function(DevEssentialRouterDelegate delegate)? emptyPage,
    required Iterable<DevEssentialPage> Function(
            DevEssentialRouteDecoder currentNavStack)
        pickPages,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    String? restorationScopeId,
    GlobalKey<NavigatorState>? navigatorKey,
    DevEssentialRouterDelegate? delegate,
  }) : super(
          pageBuilder: (context, rDelegate, pages) {
            final pageRes = <DevEssentialPage?>[
              ...?pages,
              if (pages == null || pages.isEmpty) emptyPage?.call(rDelegate),
            ].whereType<DevEssentialPage>();

            if (pageRes.isNotEmpty) {
              return InheritedNavigator(
                navigatorKey: navigatorKey ?? Dev.rootDelegate.navigatorKey,
                child: DevEssentialNavigator(
                  restorationScopeId: restorationScopeId,
                  onPopPage: onPopPage ??
                      (route, result) {
                        final didPop = route.didPop(result);
                        if (!didPop) {
                          return false;
                        }
                        return true;
                      },
                  pages: pageRes.toList(),
                  key: navigatorKey,
                ),
              );
            }
            return (emptyWidget?.call(rDelegate) ?? const SizedBox.shrink());
          },
          pickPages: pickPages,
          delegate: delegate ?? Dev.rootDelegate,
        );

  DevEssentialRouterOutlet.builder({
    super.key,
    required Widget Function(
      BuildContext context,
    ) builder,
    String? route,
    DevEssentialRouterDelegate? routerDelegate,
  }) : super.builder(
          builder: builder,
          delegate: routerDelegate ??
              (route != null ? Dev.nestedKey(route) : Dev.rootDelegate),
        );
}
