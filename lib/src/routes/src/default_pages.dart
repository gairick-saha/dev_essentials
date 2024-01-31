part of '../routes.dart';

class DevEssentialPages {
  static DevEssentialPage defaultUnknownRoute = DevEssentialPage(
    name: '/404NotFound',
    page: (context, arguments) => const Scaffold(
      body: Center(
        child: Text("Page not found."),
      ),
    ),
  );

  static List<DevEssentialPage> getPages(
    List<DevEssentialPage> userDefinedPages, {
    SplashConfig? splashConfig,
  }) =>
      [
        DevEssentialPage(
          name: _DevEssentialPaths.root,
          page: (_, __) => const RootView(),
          participatesInRootNavigator: true,
          preventDuplicates: true,
          children: [
            if (splashConfig != null)
              DevEssentialPage(
                name: _DevEssentialPaths.splash,
                page: (context, arguments) => BlocProvider<SplashCubit>(
                  create: (context) {
                    SplashCubit cubit = SplashCubit(splashConfig: splashConfig);
                    cubit.initSplash();
                    return cubit;
                  },
                  child: const SplashView(),
                ),
              ),
            ...userDefinedPages,
          ],
        ),
      ];
}
