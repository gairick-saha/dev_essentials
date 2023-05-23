part of '../navigation.dart';

class DevEssentialPage<T> extends Page<T> {
  const DevEssentialPage({
    required String name,
    Object? arguments,
    required this.builder,
  }) : super(
          name: name,
          arguments: arguments,
        );

  final WidgetBuilder builder;

  @override
  DevEssentialRoute<T> createRoute(BuildContext context) =>
      DevEssentialRoute<T>(
        settings: this,
        pageBuilder: builder,
      );
}
