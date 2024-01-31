part of '../navigation.dart';

class DevEssentialPageRoute<T> extends PageRoute<T>
    with DevEssentialPageRouteTransitionMixin<T> {
  DevEssentialPageRoute({
    required this.name,
    required this.page,
    required RouteSettings settings,
    this.arguments,
    this.barrierColor,
    this.barrierLabel,
    this.barrierDismissible = false,
    this.maintainState = true,
    this.popGesture,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.gestureWidth,
    this.middlewares = const <DevEssentialMiddleware>[],
    this.showCupertinoParallax = true,
    this.transition,
    this.customTransition,
    this.alignment,
    this.curve,
    this.opaque = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    this.title,
    this.parameter,
  }) : super(
          settings: settings,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible,
        ) {
    title ??= name;
  }

  final String name;

  final DevEssentialPageBuilder page;

  final Object? arguments;

  final Map<String, String>? parameter;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool barrierDismissible;

  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  GestureWidthCallback? gestureWidth;

  @override
  final bool showCupertinoParallax;

  @override
  final bool opaque;

  @override
  String? title;

  final bool? popGesture;

  final DevEssentialTransition? transition;

  final DevEssentialCustomTransition? customTransition;

  final Alignment? alignment;

  final Curve? curve;

  List<DevEssentialMiddleware> middlewares;

  Widget? _child;

  @override
  void dispose() {
    super.dispose();
    final middlewareRunner = _MiddlewareRunner(middlewares);
    middlewareRunner.runOnPageDispose();
    _child = null;
  }

  @override
  Widget buildContent(BuildContext context) => _getChild(context);

  Widget _getChild(BuildContext context) {
    if (_child != null) return _child!;
    final middlewareRunner = _MiddlewareRunner(middlewares);

    final pageToBuild = middlewareRunner.runOnPageBuildStart(page)!;

    final Widget p = pageToBuild(context, arguments);

    middlewareRunner.runOnPageBuilt(p);

    return _child ??= middlewareRunner.runOnPageBuilt(p);
  }
}
