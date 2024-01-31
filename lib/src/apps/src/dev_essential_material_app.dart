part of '../apps.dart';

class DevEssentialMaterialApp extends HookWidget {
  DevEssentialMaterialApp({
    Key? key,
    required this.title,
    this.pages,
    this.home,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers,
    this.builder,
    this.onGenerateTitle,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.customTransition,
    this.color,
    this.translationsKeys,
    this.translations,
    this.textDirection,
    this.locale,
    this.fallbackLocale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.scrollBehavior,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.actions,
    this.routingCallback,
    this.defaultTransition,
    this.opaqueRoute,
    this.onInit,
    this.onReady,
    this.onDispose,
    this.enableLog,
    this.logWriterCallback,
    this.popGesture,
    this.transitionDuration,
    this.defaultGlobalState,
    this.unknownRoute,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.useInheritedMediaQuery = false,
    this.showDevicePreview = false,
    this.useToastNotification = true,
    this.splashConfig,
  })  : assert(
          pages == null || home == null,
          'Either the home property must be specified, '
          'or the pages property need be specified',
        ),
        assert(
          pages == null || pages.isNotEmpty,
          'Minimum 1 page need be specified',
        ),
        super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final TransitionBuilder? builder;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  final DevEssentialCustomTransition? customTransition;
  final Color? color;
  final Map<String, Map<String, String>>? translationsKeys;
  final DevEssentialTranslations? translations;
  final TextDirection Function(BuildContext context)? textDirection;
  final Locale? locale;
  final Locale? fallbackLocale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final ScrollBehavior? scrollBehavior;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final Map<Type, Action<Intent>>? actions;
  final bool debugShowMaterialGrid;
  final ValueChanged<DevEssentialRouting?>? routingCallback;
  final DevEssentialTransition? defaultTransition;
  final bool? opaqueRoute;
  final VoidCallback? onInit;
  final VoidCallback? onReady;
  final VoidCallback? onDispose;
  final bool? enableLog;
  final DevEssentialLogWriterCallback? logWriterCallback;
  final bool? popGesture;
  final Duration? transitionDuration;
  final bool? defaultGlobalState;
  final List<DevEssentialPage>? pages;
  final DevEssentialPage? unknownRoute;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final RouterConfig<Object>? routerConfig;
  final BackButtonDispatcher? backButtonDispatcher;
  final bool useInheritedMediaQuery;
  final bool showDevicePreview;
  final bool useToastNotification;
  final SplashConfig? splashConfig;

  @override
  Widget build(BuildContext context) {
    final DevEssentialHookState rootHookState = useDevEssentialHook(
      config: DevEssentialAppConfigData(
        backButtonDispatcher: backButtonDispatcher,
        customTransition: customTransition,
        defaultGlobalState: defaultGlobalState,
        defaultTransition: defaultTransition,
        enableLog: enableLog,
        fallbackLocale: fallbackLocale,
        pages: pages,
        home: home,
        initialRoute: initialRoute,
        locale: locale,
        logWriterCallback: logWriterCallback,
        navigatorKey: navigatorKey,
        navigatorObservers: navigatorObservers,
        onDispose: onDispose,
        onInit: onInit,
        onReady: onReady,
        routeInformationParser: routeInformationParser,
        routeInformationProvider: routeInformationProvider,
        routerDelegate: routerDelegate,
        routingCallback: routingCallback,
        scaffoldMessengerKey: scaffoldMessengerKey,
        transitionDuration: transitionDuration,
        translations: translations,
        translationsKeys: translationsKeys,
        unknownRoute: unknownRoute,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        splashConfig: splashConfig,
      ),
    );

    final DevEssentialAppConfigData config = rootHookState.config;

    final _InheritedDevEssentialRootApp materialApp =
        _InheritedDevEssentialRootApp(
      devEssentialHook: rootHookState,
      child: Builder(
        builder: (context) => MaterialApp.router(
          routerDelegate: config.routerDelegate,
          routeInformationParser: config.routeInformationParser,
          backButtonDispatcher: backButtonDispatcher,
          routeInformationProvider: routeInformationProvider,
          routerConfig: routerConfig,
          key: config.unikey,
          builder: (context, child) {
            if (builder != null) {
              child = builder!(context, child);
            }
            if (useToastNotification) {
              final botToastBuilder = BotToastInit();
              child = botToastBuilder(context, child);
            }

            return Directionality(
              textDirection: textDirection?.call(context) ?? TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            );
          },
          title: title,
          onGenerateTitle: onGenerateTitle,
          color: color,
          theme: config.theme ?? ThemeData.fallback(),
          darkTheme: config.darkTheme ?? config.theme ?? ThemeData.fallback(),
          themeMode: config.themeMode,
          locale: Dev.locale ?? locale,
          scaffoldMessengerKey: config.scaffoldMessengerKey,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          debugShowMaterialGrid: debugShowMaterialGrid,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          shortcuts: shortcuts,
          scrollBehavior: scrollBehavior,
        ),
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
