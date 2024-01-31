part of '../extensions.dart';

extension MediaQueryExtension on DevEssential {
  PlatformDispatcher get window => engine.platformDispatcher;

  double get devicePixelRatio => window.implicitView!.devicePixelRatio;

  double get deviceStatusBarHeight => window.implicitView!.padding.top;

  double get deviceBottomBarHeight => window.implicitView!.padding.bottom;

  double get deviceTextScaleFactor => window.textScaleFactor;

  Size get deviceSize => window.implicitView!.physicalSize / devicePixelRatio;

  double get deviceWidth => deviceSize.width;

  double get deviceHeight => deviceSize.height;

  bool get isDeviceDarkMode => (window.platformBrightness == Brightness.dark);

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  Size get size => mediaQuery.size;

  double get width => mediaQuery.size.width;

  double get height => mediaQuery.size.height;

  double get statusBarHeight => mediaQuery.padding.top;

  double get bottomBarHeight => mediaQuery.padding.bottom;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  double textScaleFactor(double fontSize) =>
      mediaQuery.textScaler.scale(fontSize);

  TextScaler get textScaler => TextScaler.linear(deviceTextScaleFactor);

  double get pixelRatio => mediaQuery.devicePixelRatio;

  FocusNode? get focusScope => FocusManager.instance.primaryFocus;

  FlutterView get view => View.of(context);

  Locale? get viewLocale => view.platformDispatcher.locale;

  double get viewPixelRatio => view.devicePixelRatio;

  Size get viewDeviceSize => view.physicalSize / pixelRatio;

  double get viewDevicewidth => viewDeviceSize.width;

  double get viewDeviceheight => viewDeviceSize.height;

  double get viewDeviceStatusBarHeight => view.padding.top;

  double get viewDeviceBottomBarHeight => view.padding.bottom;

  ViewPadding get viewDeviceViewInsets => view.viewInsets;

  ViewPadding get viewDeviceViewPadding => view.viewPadding;

  double get viewDeviceTextScaleFactor =>
      view.platformDispatcher.textScaleFactor;

  bool get isPlatformDarkMode =>
      (view.platformDispatcher.platformBrightness == Brightness.dark);
}
