part of '../splash.dart';

class SplashCubit extends Cubit<SplashState> {
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
    _loadSplash();
  }

  void _loadSplash() async {
    Dev.print("Splash Loading...");

    if (state.splashConfig?.routeAfterSplash != null) {
      String routeWhenSplashComplete =
          await state.splashConfig!.routeAfterSplash(Dev.context);

      if (routeWhenSplashComplete.isNotEmpty) {
        Duration splashDuration =
            state.splashConfig?.splashDuration ?? 3.seconds;
        await Future.delayed(splashDuration, () {
          SplashState newStateAfterSplashCompleted =
              state.copyWith(isSplashCompleted: true);
          Dev.print("Splash Completed...");
          Dev.offAllNamed(routeWhenSplashComplete);
          emit(newStateAfterSplashCompleted);
        });
      } else {
        Dev.print('Invalid routeName: $routeWhenSplashComplete');
      }
    }
  }
}
