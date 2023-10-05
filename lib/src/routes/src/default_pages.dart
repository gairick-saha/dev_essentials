part of '../routes.dart';

class DevEssentialPages {
  static DevEssentialPage defaultUnknownRoute = DevEssentialPage(
    name: '/404NotFound',
    builder: (context, arguments) => const Scaffold(
      body: Center(
        child: Text("Page not found."),
      ),
    ),
  );

  static List<DevEssentialPage> getPages(
    List<DevEssentialPage>? userDefinedPages, {
    SplashConfig? splashConfig,
  }) {
    List<DevEssentialPage> defaultPages = [
      DevEssentialPage(
        name: _DevEssentialPaths.root,
        builder: (context, arguments) => BlocProvider<SplashCubit>(
          create: (context) {
            SplashCubit cubit = SplashCubit(
              splashConfig: splashConfig ??
                  SplashConfig(
                    routeAfterSplash: (BuildContext splashContext) async =>
                        userDefinedPages?.first.name,
                    splashDuration: 3.seconds,
                  ),
            );
            cubit.initSplash();
            return cubit;
          },
          child: const SplashView(),
        ),
      ),
    ];
    if (userDefinedPages != null) {
      defaultPages.addAll(userDefinedPages);
    }
    return defaultPages;
  }
}
