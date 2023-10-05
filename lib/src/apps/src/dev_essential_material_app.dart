part of '../apps.dart';

class DevEssentialMaterialApp extends _DevEssentialApp {
  const DevEssentialMaterialApp({
    super.key,
    required super.title,
    super.pages,
    super.home,
    super.debugShowCheckedModeBanner = true,
    super.theme,
    super.darkTheme,
    super.themeMode = ThemeMode.system,
    super.builder,
    super.navigatorObservers = const [],
    super.splashConfig,
    super.useToastNotification = true,
    super.unknownRoute,
    super.defaultTransition,
    super.defaultTransitionDuration,
    super.defaultTransitionCurve,
    super.defaultDialogTransitionCurve,
    super.defaultDialogTransitionDuration,
    super.customTransition,
    super.showDevicePreview = false,
  });

  static InheritedDevEssentialRootApp of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedDevEssentialRootApp>()!;

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) => Dev.routeGenerator(
        settings: settings,
        unknownRoute: unknownRoute,
      );

  @override
  List<Route<dynamic>> onGenerateInitialRoutes(String name) =>
      Dev.initialRouteGenerator(
        name,
        unknownRoute: unknownRoute,
      );

  @override
  Widget build(BuildContext context) {
    final Widget materialApp = _InheritedDevEssentialRootApp(
      devEssentialHook: useDevEssentialHook(
        theme: theme ?? ThemeData.fallback(),
        darkTheme: darkTheme ?? ThemeData.fallback(),
        themeMode: themeMode,
        defaultTransition: defaultTransition,
        defaultDialogTransitionCurve: defaultDialogTransitionCurve,
        defaultDialogTransitionDuration: defaultDialogTransitionDuration,
        defaultTransitionCurve: defaultTransitionCurve,
        defaultTransitionDuration: defaultTransitionDuration,
        customTransition: customTransition,
        pages: DevEssentialPages.getPages(
          pages,
          splashConfig: splashConfig,
        ),
      ),
      child: Builder(
        builder: (context) {
          final DevEssentialHookState rootHookState = Dev.of(context);
          return MaterialApp(
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            theme: rootHookState.theme,
            darkTheme: rootHookState.darkTheme,
            themeMode: rootHookState.themeMode,
            navigatorKey: rootHookState.rootNavigatorKey,
            navigatorObservers: [
              Dev.navigatorObserver(),
              BotToastNavigatorObserver(),
              ...navigatorObservers,
            ],
            builder: (BuildContext context, Widget? child) {
              if (builder != null) {
                child = builder!(context, child);
              }
              if (useToastNotification) {
                final botToastBuilder = BotToastInit();
                child = botToastBuilder(context, child);
              }
              return child ?? const SizedBox.shrink();
            },
            home: home == null && pages != null ? null : home,
            onGenerateRoute:
                pages == null && home != null ? null : onGenerateRoute,
            onGenerateInitialRoutes:
                pages == null && home != null ? null : onGenerateInitialRoutes,
          );
        },
      ),
    );

    if (!showDevicePreview) {
      return materialApp;
    }

    return DevicePreview(
      enabled: showDevicePreview,
      builder: (context) => materialApp,
    );
  }
}
