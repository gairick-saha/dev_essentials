part of '../configs.dart';

class SplashConfig {
  SplashConfig({
    this.logoPath,
    this.logoSize,
    this.logoPadding,
    this.showVersionNumber = true,
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    this.darkBackgroundColor,
    this.darkBackgroundGradient,
    this.darkForegroundColor,
    this.splashDuration,
    this.customUiBuilder,
    required this.routeAfterSplash,
  });

  final String? logoPath;
  final Size? logoSize;
  final EdgeInsetsGeometry? logoPadding;
  final bool showVersionNumber;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? foregroundColor;
  final Color? darkBackgroundColor;
  final Gradient? darkBackgroundGradient;
  final Color? darkForegroundColor;
  final Duration? splashDuration;
  final SplashUIBuilder? customUiBuilder;
  final OnSplashInitCallback routeAfterSplash;

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
    OnSplashInitCallback? routeAfterSplash,
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
        routeAfterSplash: routeAfterSplash ?? this.routeAfterSplash,
      );
}
