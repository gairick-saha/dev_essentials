part of '../extensions.dart';

extension PageArgExt on BuildContext {
  RouteSettings? get settings {
    return ModalRoute.of(this)!.settings;
  }

  DevEssentialPageSettings? get pageSettings {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args is DevEssentialPageSettings) {
      return args;
    }
    return null;
  }

  dynamic get arguments {
    final args = settings?.arguments;
    if (args is DevEssentialPageSettings) {
      return args.arguments;
    } else {
      return args;
    }
  }

  Map<String, String> get params {
    final args = settings?.arguments;
    if (args is DevEssentialPageSettings) {
      return args.params;
    } else {
      return {};
    }
  }

  Router get router {
    return Router.of(this);
  }

  String get location {
    final parser = router.routeInformationParser;
    final config = delegate.currentConfiguration;
    return parser?.restoreRouteInformation(config)?.uri.toString() ?? '/';
  }

  DevEssentialRouterDelegate get delegate =>
      router.routerDelegate as DevEssentialRouterDelegate;
}

extension ContextExt on BuildContext {
  TextDirection get textDirection => Directionality.of(this);

  Size get mediaQuerySize => MediaQuery.sizeOf(this);

  double get height => mediaQuerySize.height;

  double get width => mediaQuerySize.width;

  double heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.height -
            ((mediaQuerySize.height / 100) * reducedBy)) /
        dividedBy;
  }

  double widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.width - ((mediaQuerySize.width / 100) * reducedBy)) /
        dividedBy;
  }

  double ratio({
    double dividedBy = 1,
    double reducedByW = 0.0,
    double reducedByH = 0.0,
  }) {
    return heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
        widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);
  }

  ThemeData get theme => Theme.of(this);

  bool get isDarkMode => (theme.brightness == Brightness.dark);

  Color? get iconColor => theme.iconTheme.color;

  TextTheme get textTheme => Theme.of(this).textTheme;

  EdgeInsets get mediaQueryPadding => MediaQuery.paddingOf(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  EdgeInsets get mediaQueryViewPadding => MediaQuery.viewPaddingOf(this);

  EdgeInsets get mediaQueryViewInsets => MediaQuery.viewInsetsOf(this);

  Orientation get orientation => MediaQuery.orientationOf(this);

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  double textScaleFactor(double fontSize) =>
      MediaQuery.textScalerOf(this).scale(fontSize);

  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  bool get showNavbar => (width > 800);

  bool get isPhoneOrLess => width <= 600;

  bool get isPhoneOrWider => width >= 600;

  bool get isPhone => (mediaQueryShortestSide < 600);

  bool get isSmallTabletOrLess => width <= 600;

  bool get isSmallTabletOrWider => width >= 600;

  bool get isSmallTablet => (mediaQueryShortestSide >= 600);

  bool get isLargeTablet => (mediaQueryShortestSide >= 720);

  bool get isLargeTabletOrLess => width <= 720;

  bool get isLargeTabletOrWider => width >= 720;

  bool get isTablet => isSmallTablet || isLargeTablet;

  bool get isDesktopOrLess => width <= 1200;

  bool get isDesktopOrWider => width >= 1200;

  bool get isDesktop => isDesktopOrLess;

  T responsiveValue<T>({
    T? watch,
    T? mobile,
    T? tablet,
    T? desktop,
  }) {
    assert(
        watch != null || mobile != null || tablet != null || desktop != null);

    var deviceWidth = mediaQuerySize.width;

    final strictValues = [
      if (deviceWidth >= 1200) desktop,
      if (deviceWidth >= 600) tablet,
      if (deviceWidth >= 300) mobile,
      watch,
    ].whereType<T>();
    final looseValues = [
      watch,
      mobile,
      tablet,
      desktop,
    ].whereType<T>();
    return strictValues.firstOrNull ?? looseValues.first;
  }
}

extension IterableExt<T> on Iterable<T> {
  T? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
