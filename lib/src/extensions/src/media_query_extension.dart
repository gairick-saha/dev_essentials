part of '../extensions.dart';

extension MediaQueryAndThemeExtension on DevEssential {
  static final DevEssentialHookState _hookState =
      DevEssentialHookState.instance;

  BuildContext get context => key.currentContext!;

  BuildContext? get overlayContext {
    BuildContext? overlay;
    key.currentState?.overlay?.context.visitChildElements((element) {
      overlay = element;
    });
    return overlay;
  }

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  Size get size => mediaQuery.size;

  double get width => mediaQuery.size.width;

  double get height => mediaQuery.size.height;

  double get statusBarHeight => mediaQuery.padding.top;

  double get bottomBarHeight => mediaQuery.padding.bottom;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  double get textScaleFactor => mediaQuery.textScaleFactor;

  FocusNode? get focusScope => FocusManager.instance.primaryFocus;

  void setTheme(ThemeData themeData) => _hookState.changeThemeData(themeData);

  void setThemeMode(ThemeMode themeMode) =>
      _hookState.changeThemeMode(themeMode);

  ThemeData get theme => _hookState.theme;

  TextTheme get textTheme => theme.textTheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  Color? get iconColor => theme.iconTheme.color;

  FlutterView get view => View.of(context);

  Locale? get deviceLocale => view.platformDispatcher.locale;

  double get pixelRatio => view.devicePixelRatio;

  Size get physicalDeviceSize => view.physicalSize / pixelRatio;

  double get physicalDevicewidth => physicalDeviceSize.width;

  double get physicalDeviceheight => physicalDeviceSize.height;

  double get physicalDeviceStatusBarHeight => view.padding.top;

  double get physicalDeviceBottomBarHeight => view.padding.bottom;

  ViewPadding get physicalDeviceViewInsets => view.viewInsets;

  ViewPadding get physicalDeviceViewPadding => view.viewPadding;

  double get physicalDeviceTextScaleFactor =>
      view.platformDispatcher.textScaleFactor;

  bool get isPlatformDarkMode =>
      (view.platformDispatcher.platformBrightness == Brightness.dark);
}
