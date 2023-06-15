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

  DevEssentialPage copyWith({
    String? name,
    Object? arguments,
    WidgetBuilder? builder,
    List<DevEssentialPage>? childrens,
  }) =>
      DevEssentialPage(
        name: (name ?? this.name)!,
        arguments: arguments ?? this.arguments,
        builder: builder ?? this.builder,
        childrens: childrens ?? this.childrens,
      );
}
