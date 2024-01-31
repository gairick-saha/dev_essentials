part of '../modules.dart';

class RootView extends StatelessWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DevEssentialRouterOutlet(
      initialRoute: Dev.of(context).config.splashConfig == null
          ? (Dev.of(context).config.pages?.first.name ??
              Dev.of(context).cleanRouteName(
                  "/${Dev.of(context).config.home.runtimeType}"))
          : DevEssentialRoutes.splash,
      anchorRoute: DevEssentialRoutes.root,
    );
  }
}
