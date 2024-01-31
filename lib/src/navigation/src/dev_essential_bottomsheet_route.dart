part of '../navigation.dart';

class DevEssentialModalBottomSheetRoute<T> extends PopupRoute<T> {
  DevEssentialModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    this.backgroundColor,
    this.isPersistent,
    this.elevation,
    this.shape,
    this.removeTop = true,
    this.clipBehavior,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    required this.isScrollControlled,
    RouteSettings? settings,
    this.enterBottomSheetDuration = const Duration(milliseconds: 250),
    this.exitBottomSheetDuration = const Duration(milliseconds: 200),
    this.curve,
    this.constraints,
  }) : super(settings: settings);

  final bool? isPersistent;
  final WidgetBuilder? builder;
  final ThemeData? theme;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Color? modalBarrierColor;
  final bool isDismissible;
  final bool enableDrag;
  // final String name;
  final Duration enterBottomSheetDuration;
  final Duration exitBottomSheetDuration;
  final Curve? curve;
  // remove safearea from top
  final bool removeTop;
  final BoxConstraints? constraints;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  @override
  void dispose() {
    if (!(_animationController?.isDismissed ?? false)) {
      _animationController?.dispose();
    }
    super.dispose();
  }

  @override
  Animation<double> createAnimation() {
    if (curve != null) {
      return CurvedAnimation(curve: curve!, parent: _animationController!.view);
    }
    return _animationController!.view;
  }

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    _animationController!.duration = enterBottomSheetDuration;
    _animationController!.reverseDuration = exitBottomSheetDuration;
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final sheetTheme =
        theme?.bottomSheetTheme ?? Theme.of(context).bottomSheetTheme;
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: removeTop,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _DevEssentialModalBottomSheet<T>(
          route: this,
          backgroundColor: backgroundColor ??
              sheetTheme.modalBackgroundColor ??
              sheetTheme.backgroundColor,
          elevation:
              elevation ?? sheetTheme.modalElevation ?? sheetTheme.elevation,
          shape: shape,
          clipBehavior: clipBehavior,
          isScrollControlled: isScrollControlled,
          enableDrag: enableDrag,
          constraints: constraints,
        ),
      ),
    );
    if (theme != null) bottomSheet = Theme(data: theme!, child: bottomSheet);
    return bottomSheet;
  }
}

class _DevEssentialModalBottomSheet<T> extends StatefulWidget {
  const _DevEssentialModalBottomSheet({
    Key? key,
    this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.isScrollControlled = false,
    this.enableDrag = true,
    this.isPersistent = false,
    this.constraints,
  }) : super(key: key);
  final bool isPersistent;
  final DevEssentialModalBottomSheetRoute<T>? route;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableDrag;
  final BoxConstraints? constraints;

  @override
  _DevEssentialModalBottomSheetState<T> createState() =>
      _DevEssentialModalBottomSheetState<T>();
}

class _DevEssentialModalBottomSheetState<T>
    extends State<_DevEssentialModalBottomSheet<T>> {
  String _getRouteLabel(MaterialLocalizations localizations) {
    if ((Theme.of(context).platform == TargetPlatform.android) ||
        (Theme.of(context).platform == TargetPlatform.fuchsia)) {
      return localizations.dialogLabel;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final mediaQuery = MediaQuery.of(context);
    final localizations = MaterialLocalizations.of(context);
    final routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route!.animation!,
      builder: (context, child) {
        // Disable the initial animation when accessible navigation is on so
        // that the semantics are added to the tree at the correct time.
        final animationValue = mediaQuery.accessibleNavigation
            ? 1.0
            : widget.route!.animation!.value;
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: CustomSingleChildLayout(
                delegate: _DevEssentialModalBottomSheetLayout(
                    animationValue, widget.isScrollControlled),
                child: widget.isPersistent == false
                    ? BottomSheet(
                        animationController: widget.route!._animationController,
                        onClosing: () {
                          if (widget.route!.isCurrent) {
                            Navigator.pop(context);
                          }
                        },
                        builder: widget.route!.builder!,
                        backgroundColor: widget.backgroundColor,
                        elevation: widget.elevation,
                        shape: widget.shape,
                        clipBehavior: widget.clipBehavior,
                        enableDrag: widget.enableDrag,
                        constraints: widget.constraints,
                      )
                    : Scaffold(
                        bottomSheet: BottomSheet(
                          animationController:
                              widget.route!._animationController,
                          onClosing: () {
                            // if (widget.route.isCurrent) {
                            //   Navigator.pop(context);
                            // }
                          },
                          builder: widget.route!.builder!,
                          backgroundColor: widget.backgroundColor,
                          elevation: widget.elevation,
                          shape: widget.shape,
                          clipBehavior: widget.clipBehavior,
                          enableDrag: widget.enableDrag,
                          constraints: widget.constraints,
                        ),
                      )),
          ),
        );
      },
    );
  }
}

class _DevEssentialPerModalBottomSheet<T> extends StatefulWidget {
  const _DevEssentialPerModalBottomSheet({
    Key? key,
    this.route,
    this.isPersistent,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.isScrollControlled = false,
    this.enableDrag = true,
  }) : super(key: key);
  final bool? isPersistent;
  final DevEssentialModalBottomSheetRoute<T>? route;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableDrag;

  @override
  // ignore: lines_longer_than_80_chars
  _DevEssentialPerModalBottomSheetState<T> createState() =>
      _DevEssentialPerModalBottomSheetState<T>();
}

// ignore: lines_longer_than_80_chars
class _DevEssentialPerModalBottomSheetState<T>
    extends State<_DevEssentialPerModalBottomSheet<T>> {
  String _getRouteLabel(MaterialLocalizations localizations) {
    if ((Theme.of(context).platform == TargetPlatform.android) ||
        (Theme.of(context).platform == TargetPlatform.fuchsia)) {
      return localizations.dialogLabel;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final mediaQuery = MediaQuery.of(context);
    final localizations = MaterialLocalizations.of(context);
    final routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route!.animation!,
      builder: (context, child) {
        // Disable the initial animation when accessible navigation is on so
        // that the semantics are added to the tree at the correct time.
        final animationValue = mediaQuery.accessibleNavigation
            ? 1.0
            : widget.route!.animation!.value;
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: CustomSingleChildLayout(
                delegate: _DevEssentialModalBottomSheetLayout(
                    animationValue, widget.isScrollControlled),
                child: widget.isPersistent == false
                    ? BottomSheet(
                        animationController: widget.route!._animationController,
                        onClosing: () {
                          if (widget.route!.isCurrent) {
                            Navigator.pop(context);
                          }
                        },
                        builder: widget.route!.builder!,
                        backgroundColor: widget.backgroundColor,
                        elevation: widget.elevation,
                        shape: widget.shape,
                        clipBehavior: widget.clipBehavior,
                        enableDrag: widget.enableDrag,
                      )
                    : Scaffold(
                        bottomSheet: BottomSheet(
                          animationController:
                              widget.route!._animationController,
                          onClosing: () {
                            // if (widget.route.isCurrent) {
                            //   Navigator.pop(context);
                            // }
                          },
                          builder: widget.route!.builder!,
                          backgroundColor: widget.backgroundColor,
                          elevation: widget.elevation,
                          shape: widget.shape,
                          clipBehavior: widget.clipBehavior,
                          enableDrag: widget.enableDrag,
                        ),
                      )),
          ),
        );
      },
    );
  }
}

class _DevEssentialModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _DevEssentialModalBottomSheetLayout(this.progress, this.isScrollControlled);

  final double progress;
  final bool isScrollControlled;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: isScrollControlled
          ? constraints.maxHeight
          : constraints.maxHeight * 9.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_DevEssentialModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
