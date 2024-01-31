// ignore_for_file: overridden_fields

part of '../navigation.dart';

class DevEssentialPageSettings extends RouteSettings {
  DevEssentialPageSettings(
    this.uri, [
    Object? arguments,
  ]) : super(arguments: arguments);

  @override
  String get name => '$uri';

  final Uri uri;

  final params = <String, String>{};

  String get path => uri.path;

  List<String> get paths => uri.pathSegments;

  Map<String, String> get query => uri.queryParameters;

  Map<String, List<String>> get queries => uri.queryParametersAll;

  @override
  String toString() => name;

  DevEssentialPageSettings copy({
    Uri? uri,
    Object? arguments,
  }) {
    return DevEssentialPageSettings(
      uri ?? this.uri,
      arguments ?? this.arguments,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DevEssentialPageSettings &&
        other.uri == uri &&
        other.arguments == arguments;
  }

  @override
  int get hashCode => uri.hashCode ^ arguments.hashCode;
}

class DevEssentialPage<T> extends Page<T> {
  DevEssentialPage({
    required this.name,
    required this.page,
    this.arguments,
    this.parameters,
    LocalKey? key,
    String? restorationId,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    this.participatesInRootNavigator,
    this.children = const <DevEssentialPage>[],
    this.middlewares = const <DevEssentialMiddleware>[],
    this.transition,
    this.customTransition,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.curve = Curves.linear,
    this.showCupertinoParallax = true,
    this.preventDuplicates = true,
    this.title,
    this.preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
    this.popGesture,
    this.alignment,
    this.opaque = true,
    this.gestureWidth,
    this.unknownRoute,
    this.completer,
    this.inheritParentPath = true,
  })  : path = PathDecoded._nameToRegex(name),
        assert(name.startsWith('/'),
            'It is necessary to start route name [$name] with a slash: /$name'),
        super(
          key: key ?? ValueKey(name),
          name: name,
          arguments: arguments,
          restorationId: restorationId,
        );

  final DevEssentialPageBuilder page;
  @override
  final String name;
  @override
  final Object? arguments;
  final Map<String, String>? parameters;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool allowSnapshotting;
  final bool? participatesInRootNavigator;
  final List<DevEssentialPage> children;
  final List<DevEssentialMiddleware> middlewares;
  final DevEssentialTransition? transition;
  final DevEssentialCustomTransition? customTransition;
  final Duration? transitionDuration;
  final Duration? reverseTransitionDuration;
  final Curve curve;
  final bool preventDuplicates;
  final String? title;
  final bool showCupertinoParallax;
  final PreventDuplicateHandlingMode preventDuplicateHandlingMode;
  final Alignment? alignment;
  final bool? popGesture;
  final bool opaque;
  final GestureWidthCallback? gestureWidth;
  final DevEssentialPage? unknownRoute;
  final Completer<T?>? completer;
  final bool inheritParentPath;

  final PathDecoded path;

  DevEssentialPage<T> copyWith({
    LocalKey? key,
    String? name,
    DevEssentialPageBuilder? page,
    bool? popGesture,
    Map<String, String>? parameters,
    String? title,
    DevEssentialTransition? transition,
    Curve? curve,
    Alignment? alignment,
    bool? maintainState,
    bool? opaque,
    DevEssentialCustomTransition? customTransition,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    bool? fullscreenDialog,
    RouteSettings? settings,
    List<DevEssentialPage<T>>? children,
    DevEssentialPage? unknownRoute,
    List<DevEssentialMiddleware>? middlewares,
    bool? preventDuplicates,
    GestureWidthCallback? gestureWidth,
    bool? participatesInRootNavigator,
    Object? arguments,
    bool? showCupertinoParallax,
    Completer<T?>? completer,
    bool? inheritParentPath,
  }) {
    return DevEssentialPage<T>(
      key: key ?? this.key,
      participatesInRootNavigator:
          participatesInRootNavigator ?? this.participatesInRootNavigator,
      preventDuplicates: preventDuplicates ?? this.preventDuplicates,
      name: name ?? this.name,
      page: page ?? this.page,
      popGesture: popGesture ?? this.popGesture,
      parameters: parameters ?? this.parameters,
      title: title ?? this.title,
      transition: transition ?? this.transition,
      curve: curve ?? this.curve,
      alignment: alignment ?? this.alignment,
      maintainState: maintainState ?? this.maintainState,
      opaque: opaque ?? this.opaque,
      customTransition: customTransition ?? this.customTransition,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
      fullscreenDialog: fullscreenDialog ?? this.fullscreenDialog,
      children: children ?? this.children,
      unknownRoute: unknownRoute ?? this.unknownRoute,
      middlewares: middlewares ?? this.middlewares,
      gestureWidth: gestureWidth ?? this.gestureWidth,
      arguments: arguments ?? this.arguments,
      showCupertinoParallax:
          showCupertinoParallax ?? this.showCupertinoParallax,
      completer: completer ?? this.completer,
      inheritParentPath: inheritParentPath ?? this.inheritParentPath,
    );
  }

  @override
  Route<T> createRoute(BuildContext context) {
    final page = PageRedirect(
      route: this,
      settings: this,
      unknownRoute: unknownRoute,
    ).getPageToRoute<T>(this, unknownRoute, context);

    return page;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DevEssentialPage<T> && other.key == key;
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'Page')}("$name", $key, $arguments)';

  @override
  int get hashCode {
    return key.hashCode;
  }
}
