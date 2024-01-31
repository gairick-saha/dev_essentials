part of '../hooks.dart';

DevEssentialHookState useDevEssentialHook({
  required DevEssentialAppConfigData config,
}) =>
    use(DevEssentialHook(
      config: config,
    ));

class DevEssentialHook extends Hook<DevEssentialHookState> {
  const DevEssentialHook({
    required this.config,
  });

  final DevEssentialAppConfigData config;

  @override
  HookState<DevEssentialHookState, Hook<DevEssentialHookState>> createState() =>
      DevEssentialHookState();
}

class DevEssentialHookState
    extends HookState<DevEssentialHookState, DevEssentialHook>
    with WidgetsBindingObserver {
  static DevEssentialHookState? _instance;
  static DevEssentialHookState get instance {
    if (_instance == null) {
      throw Exception('DevEssentialHookState is not part of the tree');
    } else {
      return _instance!;
    }
  }

  late DevEssentialAppConfigData config;

  @override
  void dispose() {
    config.onDispose?.call();
    Dev.clearTranslations();
    _instance = null;
    Engine.removeObserver(this);
    super.dispose();
  }

  @override
  void initHook() {
    config = hook.config;
    Engine.addObserver(this);
    DevEssentialHookState._instance = this;
    onInit();
    super.initHook();
  }

  void onInit() {
    if (config.unknownRoute == null) {
      config =
          config.copyWith(unknownRoute: DevEssentialPages.defaultUnknownRoute);
    }

    if (config.navigatorObservers == null) {
      config = config.copyWith(
        navigatorObservers: <NavigatorObserver>[
          DevEssentialNavigationObserver(
            config.routingCallback,
            Dev.routing,
          ),
          BotToastNavigatorObserver(),
        ],
      );
    } else {
      config = config.copyWith(
        navigatorObservers: <NavigatorObserver>[
          DevEssentialNavigationObserver(
            config.routingCallback,
            config.routing,
          ),
          BotToastNavigatorObserver(),
          ...config.navigatorObservers!
        ],
      );
    }

    if (config.routerDelegate == null) {
      final newDelegate = DevEssentialRouterDelegate.createDelegate(
        pages: DevEssentialPages.getPages(
          config.pages ??
              [
                DevEssentialPage(
                  name: cleanRouteName("/${config.home.runtimeType}"),
                  page: (_, __) =>
                      config.home ??
                      const Scaffold(
                        body: Center(
                          child: Text('No pages of home provided'),
                        ),
                      ),
                ),
              ],
          splashConfig: config.splashConfig,
        ),
        notFoundRoute: config.unknownRoute,
        navigatorKey: config.navigatorKey,
        navigatorObservers: config.navigatorObservers,
      );

      config = config.copyWith(routerDelegate: newDelegate);

      if (config.routeInformationParser == null) {
        final newRouteInformationParser =
            DevEssentialRouteInformationParser.createInformationParser(
          initialRoute: config.initialRoute ??
              config.pages?.first.name ??
              cleanRouteName("/${config.home.runtimeType}"),
        );

        config =
            config.copyWith(routeInformationParser: newRouteInformationParser);
      }

      if (config.locale != null) Dev.locale = config.locale;

      if (config.fallbackLocale != null) {
        Dev.fallbackLocale = config.fallbackLocale;
      }

      if (config.translations != null) {
        Dev.addTranslations(config.translations!.keys);
      } else if (config.translationsKeys != null) {
        Dev.addTranslations(config.translationsKeys!);
      }

      config.onInit?.call();

      Dev.isLogEnable = config.enableLog ?? kDebugMode;
      Dev.log = config.logWriterCallback ?? defaultLogWriterCallback;

      Engine.schedulerBinding.addPostFrameCallback((_) {
        if (config.defaultTransition == null) {
          config = config.copyWith(defaultTransition: getThemeTransition());
        }
      });

      onReady();
    }
  }

  DevEssentialTransition? getThemeTransition() {
    final platform = context.theme.platform;
    final matchingTransition =
        Theme.of(context).pageTransitionsTheme.builders[platform];
    switch (matchingTransition) {
      case CupertinoPageTransitionsBuilder():
        return DevEssentialTransition.cupertino;
      case ZoomPageTransitionsBuilder():
        return DevEssentialTransition.zoom;
      case FadeUpwardsPageTransitionsBuilder():
        return DevEssentialTransition.fade;
      case OpenUpwardsPageTransitionsBuilder():
        return DevEssentialTransition.native;
      default:
        return DevEssentialTransition.native;
    }
  }

  void onReady() => config.onReady?.call();

  set parameters(Map<String, String?> newParameters) =>
      config = config.copyWith(parameters: newParameters);

  set testMode(bool isTest) => config = config.copyWith(testMode: isTest);

  @override
  void didChangeLocales(List<Locale>? locales) {
    Dev.asap(() {
      final locale = Dev.deviceLocale;
      if (locale != null) {
        Dev.updateLocale(locale);
      }
    });
  }

  void setTheme(ThemeData value) {
    if (config.darkTheme == null) {
      config = config.copyWith(theme: value);
    } else {
      if (value.brightness == Brightness.light) {
        config = config.copyWith(theme: value);
      } else {
        config = config.copyWith(darkTheme: value);
      }
    }
    update();
  }

  void setThemeMode(ThemeMode value) {
    config = config.copyWith(themeMode: value);
    update();
  }

  void restartApp() {
    config = config.copyWith(unikey: UniqueKey());
    update();
  }

  void update() {
    context.visitAncestorElements((element) {
      element.markNeedsBuild();
      return false;
    });
  }

  DevEssentialRouterDelegate get rootDelegate =>
      config.routerDelegate as DevEssentialRouterDelegate;

  RouteInformationParser<Object> get informationParser =>
      config.routeInformationParser!;

  GlobalKey<NavigatorState> get key => rootDelegate.navigatorKey;

  GlobalKey<NavigatorState>? addKey(GlobalKey<NavigatorState> newKey) {
    rootDelegate.navigatorKey = newKey;
    return key;
  }

  Map<String, DevEssentialRouterDelegate> keys = {};

  DevEssentialRouterDelegate? nestedKey(String? key) {
    if (key == null) {
      return rootDelegate;
    }
    keys.putIfAbsent(
      key,
      () => DevEssentialRouterDelegate(
        showHashOnUrl: true,
        pages: DevEssentialRouteDecoder.fromRoute(key).currentChildren ?? [],
        notFoundRoute: config.unknownRoute,
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: key),
        navigatorObservers: config.navigatorObservers,
      ),
    );
    return keys[key];
  }

  @override
  DevEssentialHookState build(BuildContext context) {
    return this;
  }

  String cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }
}
