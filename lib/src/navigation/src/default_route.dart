part of '../navigation.dart';

class DevEssentialRoute<T> extends PageRoute<T> with _RouteTransitionMixin<T> {
  DevEssentialRoute({
    RouteSettings? settings,
    this.pageBuilder,
    this.maintainState = true,
    this.barrierColor,
    this.barrierLabel,
    this.transition,
    this.curve,
    this.customTransition,
    this.gestureWidth,
    this.showCupertinoParallax = true,
    this.opaque = true,
    this.popGesture,
    this.barrierDismissible = false,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
  }) : super(
          settings: settings,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
        );

  final WidgetBuilder? pageBuilder;

  @override
  final bool showCupertinoParallax;

  @override
  final bool opaque;
  final bool? popGesture;

  @override
  final bool barrierDismissible;

  @override
  bool maintainState;

  @override
  Color? barrierColor;

  @override
  String? barrierLabel;

  final DevEssentialTransition? transition;
  final DevEssentialCustomTransition? customTransition;
  final Curve? curve;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  Widget? _child;

  Widget _getChild(BuildContext context) {
    if (_child != null) return _child!;
    _child = pageBuilder!(context);
    return _child!;
  }

  @override
  Widget buildContent(BuildContext context) => _getChild(context);

  @override
  final double Function(BuildContext context)? gestureWidth;
}
