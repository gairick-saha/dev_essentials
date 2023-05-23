part of '../navigation.dart';

const double _kBackGestureWidth = 20.0;
const int _kMaxDroppedSwipePageForwardAnimationTime = 800;

const int _kMaxPageBackAnimationTime = 300;

const double _kMinFlingVelocity = 1.0;

class CupertinoBackGestureController<T> {
  final AnimationController controller;

  final NavigatorState navigator;

  CupertinoBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  void dragEnd(double velocity) {
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    final bool animateForward;

    if (velocity.abs() >= _kMinFlingVelocity) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      final droppedPageForwardAnimationTime = min(
        lerpDouble(
                _kMaxDroppedSwipePageForwardAnimationTime, 0, controller.value)!
            .floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(1.0,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: animationCurve);
    } else {
      navigator.pop();

      if (controller.isAnimating) {
        final droppedPageBackAnimationTime = lerpDouble(
                0, _kMaxDroppedSwipePageForwardAnimationTime, controller.value)!
            .floor();
        controller.animateBack(0.0,
            duration: Duration(milliseconds: droppedPageBackAnimationTime),
            curve: animationCurve);
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }

  void dragUpdate(double delta) {
    controller.value -= delta;
  }
}

class CupertinoBackGestureDetector<T> extends StatefulWidget {
  final Widget child;

  final double gestureWidth;
  final ValueGetter<bool> enabledCallback;

  final ValueGetter<CupertinoBackGestureController<T>> onStartPopGesture;

  const CupertinoBackGestureDetector({
    Key? key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
    required this.gestureWidth,
  }) : super(key: key);

  @override
  CupertinoBackGestureDetectorState<T> createState() =>
      CupertinoBackGestureDetectorState<T>();
}

class CupertinoBackGestureDetectorState<T>
    extends State<CupertinoBackGestureDetector<T>> {
  CupertinoBackGestureController<T>? _backGestureController;

  late HorizontalDragGestureRecognizer _recognizer;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    var dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.of(context).padding.left
        : MediaQuery.of(context).padding.right;
    dragAreaWidth = max(dragAreaWidth, widget.gestureWidth);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0.0,
          width: dragAreaWidth,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  void _handleDragCancel() {
    assert(mounted);

    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(_convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width));
    _backGestureController = null;
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
        _convertToLogical(details.primaryDelta! / context.size!.width));
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) _recognizer.addPointer(event);
  }
}

mixin _RouteTransitionMixin<T> on PageRoute<T> {
  ValueNotifier<String?>? _previousTitle;

  ValueListenable<String?> get previousTitle {
    assert(
      _previousTitle != null,
      '''
        Cannot read the previousTitle for a route that has not yet been installed''',
    );
    return _previousTitle!;
  }

  @override
  Duration get transitionDuration => 400.milliseconds;

  @protected
  Widget buildContent(BuildContext context);

  double Function(BuildContext context)? get gestureWidth;

  bool get showCupertinoParallax;

  bool get popGestureEnabled => _isPopGestureEnabled(this);

  bool get popGestureInProgress => isPopGestureInProgress(this);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget child = buildContent(context);
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
    return result;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return buildPageTransitions<T>(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return (nextRoute is _RouteTransitionMixin &&
            !nextRoute.fullscreenDialog &&
            nextRoute.showCupertinoParallax) ||
        (nextRoute is CupertinoRouteTransitionMixin &&
            !nextRoute.fullscreenDialog);
  }

  @override
  void didChangePrevious(Route<dynamic>? previousRoute) {
    final previousTitleString = previousRoute is CupertinoRouteTransitionMixin
        ? previousRoute.title
        : null;
    if (_previousTitle == null) {
      _previousTitle = ValueNotifier<String?>(previousTitleString);
    } else {
      _previousTitle!.value = previousTitleString;
    }
    super.didChangePrevious(previousRoute);
  }

  static Widget buildPageTransitions<T>(
    PageRoute<T> rawRoute,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final route = rawRoute as DevEssentialRoute<T>;
    final linearTransition = isPopGestureInProgress(route);
    final finalCurve = route.curve ?? Dev.defaultTransitionCurve;
    final hasCurve = route.curve != null;
    if (route.fullscreenDialog && route.transition == null) {
      return CupertinoFullscreenDialogTransition(
        primaryRouteAnimation: hasCurve
            ? CurvedAnimation(
                parent: animation,
                curve: finalCurve,
              )
            : animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: linearTransition,
        child: child,
      );
    } else {
      if (route.customTransition != null) {
        return route.customTransition!.buildTransition(
          context,
          finalCurve,
          animation,
          secondaryAnimation,
          route.popGesture ?? Dev.defaultPopGesture
              ? CupertinoBackGestureDetector<T>(
                  gestureWidth:
                      route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                  enabledCallback: () => _isPopGestureEnabled<T>(route),
                  onStartPopGesture: () => _startPopGesture<T>(route),
                  child: child)
              : child,
        );
      }

      final iosAnimation = animation;
      animation = CurvedAnimation(parent: animation, curve: finalCurve);

      switch (route.transition ?? Dev.defaultTransition) {
        case DevEssentialTransition.leftToRight:
          return SlideLeftTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.downToUp:
          return SlideDownTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.upToDown:
          return SlideTopTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.noTransition:
          return route.popGesture ?? Dev.defaultPopGesture
              ? CupertinoBackGestureDetector<T>(
                  gestureWidth:
                      route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                  enabledCallback: () => _isPopGestureEnabled<T>(route),
                  onStartPopGesture: () => _startPopGesture<T>(route),
                  child: child)
              : child;

        case DevEssentialTransition.rightToLeft:
          return SlideRightTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.zoom:
          return ZoomInTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.fadeIn:
          return FadeInTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.rightToLeftWithFade:
          return RightToLeftFadeTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.leftToRightWithFade:
          return LeftToRightFadeTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.cupertino:
          return CupertinoPageTransition(
            primaryRouteAnimation: animation,
            secondaryRouteAnimation: secondaryAnimation,
            linearTransition: linearTransition,
            child: CupertinoBackGestureDetector<T>(
              gestureWidth:
                  route.gestureWidth?.call(context) ?? _kBackGestureWidth,
              enabledCallback: () => _isPopGestureEnabled<T>(route),
              onStartPopGesture: () => _startPopGesture<T>(route),
              child: child,
            ),
          );

        case DevEssentialTransition.size:
          return SizeTransitions().buildTransitions(
            context,
            route.curve!,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.fade:
          return const FadeUpwardsPageTransitionsBuilder().buildTransitions(
            route,
            context,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.topLevel:
          return const ZoomPageTransitionsBuilder().buildTransitions(
            route,
            context,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.native:
          return const PageTransitionsTheme().buildTransitions(
            route,
            context,
            iosAnimation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        case DevEssentialTransition.circularReveal:
          return CircularRevealTransition().buildTransitions(
            context,
            route.curve,
            animation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );

        default:
          if (Dev.customTransition != null) {
            return Dev.customTransition!.buildTransition(
              context,
              route.curve,
              animation,
              secondaryAnimation,
              child,
            );
          }

          return const PageTransitionsTheme().buildTransitions(
            route,
            context,
            iosAnimation,
            secondaryAnimation,
            route.popGesture ?? Dev.defaultPopGesture
                ? CupertinoBackGestureDetector<T>(
                    gestureWidth:
                        route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                    enabledCallback: () => _isPopGestureEnabled<T>(route),
                    onStartPopGesture: () => _startPopGesture<T>(route),
                    child: child,
                  )
                : child,
          );
      }
    }
  }

  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator!.userGestureInProgress;
  }

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    if (route.isFirst) return false;

    if (route.willHandlePopInternally) return false;

    if (route.hasScopedWillPopCallback) return false;

    if (route.fullscreenDialog) return false;

    if (route.animation!.status != AnimationStatus.completed) return false;

    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }

    if (isPopGestureInProgress(route)) return false;

    return true;
  }

  static CupertinoBackGestureController<T> _startPopGesture<T>(
      PageRoute<T> route) {
    assert(_isPopGestureEnabled(route));

    return CupertinoBackGestureController<T>(
      navigator: route.navigator!,
      controller: route.controller!,
    );
  }
}
