part of '../navigation.dart';

class DevEssentialPage extends Page {
  const DevEssentialPage({
    required String name,
    Object? arguments,
    required this.builder,
    this.childrens,
  }) : super(
          name: name,
          arguments: arguments,
        );

  final WidgetBuilder builder;

  final List<DevEssentialPage>? childrens;

  @override
  DevEssentialRoute createRoute(BuildContext context) => DevEssentialRoute(
        settings: this,
        pageBuilder: builder,
      );
}
