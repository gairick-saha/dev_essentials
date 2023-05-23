part of '../configs.dart';

class SplashConfig {
  SplashConfig({
    this.logoPath,
    this.logoSize,
    this.logoPadding,
    this.showVersionNumber = true,
    this.backgroundColor,
    this.foregroundColor,
    this.darkBackgroundColor,
    this.darkForegroundColor,
    this.splashDuration = const Duration(seconds: 3),
    this.customUiBuilder,
    this.onSplashInitCallback,
    this.routeAfterSplash,
  });

  final String? logoPath;
  final Size? logoSize;
  final EdgeInsetsGeometry? logoPadding;
  final bool showVersionNumber;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? darkBackgroundColor;
  final Color? darkForegroundColor;
  final Duration splashDuration;
  final SplashUIBuilder? customUiBuilder;
  final OnSplashInitCallback? onSplashInitCallback;
  final String? routeAfterSplash;

  SplashConfig copyWith({
    String? logoPath,
    Size? logoSize,
    EdgeInsetsGeometry? logoPadding,
    bool? showVersionNumber,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? darkBackgroundColor,
    Color? darkForegroundColor,
    Duration? splashDuration,
    SplashUIBuilder? customUiBuilder,
    OnSplashInitCallback? onSplashInitCallback,
    String? routeAfterSplash,
  }) =>
      SplashConfig(
        logoPath: logoPath ?? this.logoPath,
        logoSize: logoSize ?? this.logoSize,
        logoPadding: logoPadding ?? this.logoPadding,
        showVersionNumber: showVersionNumber ?? this.showVersionNumber,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        darkBackgroundColor: darkBackgroundColor ?? this.darkBackgroundColor,
        darkForegroundColor: darkForegroundColor ?? this.darkForegroundColor,
        splashDuration: splashDuration ?? this.splashDuration,
        customUiBuilder: customUiBuilder ?? this.customUiBuilder,
        onSplashInitCallback: onSplashInitCallback ?? this.onSplashInitCallback,
        routeAfterSplash: routeAfterSplash ?? this.routeAfterSplash,
      );
}
