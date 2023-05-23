part of '../splash.dart';

class SplashCubit extends DevEssentialCubit<SplashState> {
  SplashCubit({
    required SplashConfig? splashConfig,
  }) : super(SplashState(
          isSplashCompleted: false,
          splashConfig: splashConfig,
          appVersion: '',
        ));

  void initSplash() async {
    Dev.print("Splash Started...");
    PackageInfo packageInfo = await Dev.getPackageInfo();
    SplashState newStateBeforSplashStarted = state.copyWith(
      isSplashCompleted: false,
      appVersion: packageInfo.version,
    );
    emit(newStateBeforSplashStarted);
  }

  void loadSplash() async {
    Dev.print("Splash Loading...");

    Duration splashDuration = state.splashConfig?.splashDuration ?? 3.seconds;

    String routeWhenSplashComplete =
        state.splashConfig?.routeAfterSplash ?? DevEssentialRoutes.auth;

    await Future.delayed(splashDuration, () {
      SplashState newStateAfterSplashCompleted =
          state.copyWith(isSplashCompleted: true);
      Dev.print("Splash Completed...");
      Dev.offNamed(routeWhenSplashComplete);
      emit(newStateAfterSplashCompleted);
    });
  }
}
