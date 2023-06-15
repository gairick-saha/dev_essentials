part of '../apps.dart';

class DevEssentialMaterialApp extends HookWidget {
  const DevEssentialMaterialApp({
    Key? key,
    required this.title,
    this.pages,
    this.home,
    this.debugShowCheckedModeBanner = true,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.builder,
    this.navigatorObservers = const [],
    this.splashConfig,
    this.useToastNotification = true,
    this.unknownRoute,
    this.defaultTransition,
    this.defaultTransitionDuration,
    this.defaultTransitionCurve,
    this.defaultDialogTransitionCurve,
    this.defaultDialogTransitionDuration,
    this.customTransition,
    this.showDevicePreview = false,
  })  : assert(
          pages == null || home == null,
          'Either the home property must be specified, '
          'or the pages property need be specified',
        ),
        super(key: key);

  final String title;
  final List<DevEssentialPage>? pages;
  final Widget? home;
  final bool debugShowCheckedModeBanner;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  final TransitionBuilder? builder;
  final List<NavigatorObserver> navigatorObservers;
  final SplashConfig? splashConfig;
  final bool useToastNotification;
  final DevEssentialPage? unknownRoute;
  final DevEssentialTransition? defaultTransition;
  final Duration? defaultTransitionDuration;
  final Curve? defaultTransitionCurve;
  final Curve? defaultDialogTransitionCurve;
  final Duration? defaultDialogTransitionDuration;
  final DevEssentialCustomTransition? customTransition;
  final bool showDevicePreview;

  static InheritedDevEssentialRootApp of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedDevEssentialRootApp>()!;

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
            navigatorKey: rootHookState.routing.rootNavigatorKey,
            navigatorObservers: [
              Dev.navigatorObserver,
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
            onGenerateRoute: pages == null && home != null ? null : generator,
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

  Route<dynamic> generator(RouteSettings settings) => PagePredict(
        settings: settings,
        unknownRoute: unknownRoute ?? DevEssentialPages.defaultUnknownRoute,
      ).page();
}
