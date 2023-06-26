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
      if (splashConfig != null)
        DevEssentialPage(
          name: _DevEssentialPaths.root,
          builder: (context, arguments) => BlocProvider<SplashCubit>(
            create: (context) {
              SplashCubit cubit = SplashCubit(splashConfig: splashConfig);
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
