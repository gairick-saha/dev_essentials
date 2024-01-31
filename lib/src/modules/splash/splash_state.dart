part of '../modules.dart';

class SplashState {
  SplashState({
    required this.isSplashCompleted,
    required this.splashConfig,
    required this.appVersion,
  });

  final bool isSplashCompleted;
  final SplashConfig? splashConfig;
  final String appVersion;

  SplashState copyWith({
    bool? isSplashCompleted,
    SplashConfig? splashConfig,
    String? appVersion,
  }) =>
      SplashState(
        isSplashCompleted: isSplashCompleted ?? this.isSplashCompleted,
        splashConfig: splashConfig ?? this.splashConfig,
        appVersion: appVersion ?? this.appVersion,
      );
}
