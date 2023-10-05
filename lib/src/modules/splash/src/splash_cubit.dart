part of '../splash.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required SplashConfig splashConfig,
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
    _loadSplash();
  }

  void _loadSplash() async {
    Dev.print("Splash Loading...");

    String routeWhenSplashComplete =
        await state.splashConfig.routeAfterSplash(Dev.context) ?? '';

    if (routeWhenSplashComplete.isNotEmpty) {
      Duration? splashDuration = state.splashConfig.splashDuration;
      late SplashState newStateAfterSplashCompleted;
      if (splashDuration != null) {
        Dev.print("Splash loading for ${splashDuration.inSeconds} seconds...");
        await Future.delayed(splashDuration, () {
          newStateAfterSplashCompleted =
              state.copyWith(isSplashCompleted: true);
        });
      } else {
        Dev.print("Splash loading...");
        newStateAfterSplashCompleted = state.copyWith(isSplashCompleted: true);
      }

      Dev.print("Splash Completed...");
      Dev.offAllNamed(routeWhenSplashComplete);
      emit(newStateAfterSplashCompleted);
    } else {
      Dev.print('Invalid routeName: $routeWhenSplashComplete');
    }
  }
}
