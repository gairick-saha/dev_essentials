part of '../../navigation.dart';

const double _kBackGestureWidth = 20.0;

const double _kMinFlingVelocity = 1;

const int _kMaxMidSwipePageForwardAnimationTime = 800;

const int _kMaxPageBackAnimationTime = 300;

class DevEssentialBackGestureController<T> {
  DevEssentialBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  void dragUpdate(double delta) {
    controller.value -= delta;
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
        lerpDouble(_kMaxMidSwipePageForwardAnimationTime, 0, controller.value)!
            .floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(1.0,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: animationCurve);
    } else {
      Dev.back();

      if (controller.isAnimating) {
        final droppedPageBackAnimationTime = lerpDouble(
                0, _kMaxMidSwipePageForwardAnimationTime, controller.value)!
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
}

class DevEssentialBackGestureDetector<T> extends StatefulWidget {
  const DevEssentialBackGestureDetector({
    Key? key,
    required this.limitedSwipe,
    required this.gestureWidth,
    required this.initialOffset,
    required this.popGestureEnable,
    required this.onStartPopGesture,
    required this.child,
  }) : super(key: key);

  final bool limitedSwipe;
  final double gestureWidth;
  final double initialOffset;

  final Widget child;
  final ValueGetter<bool> popGestureEnable;
  final ValueGetter<DevEssentialBackGestureController<T>> onStartPopGesture;

  @override
  DevEssentialBackGestureDetectorState<T> createState() =>
      DevEssentialBackGestureDetectorState<T>();
}

class DevEssentialBackGestureDetectorState<T>
    extends State<DevEssentialBackGestureDetector<T>> {
  DevEssentialBackGestureController<T>? _backGestureController;

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
      _convertToLogical(details.primaryDelta! / context.size!.width),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(_convertToLogical(
      details.velocity.pixelsPerSecond.dx / context.size!.width,
    ));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);

    _backGestureController?.dragEnd(0);
    _backGestureController = null;
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final gestureDetector = RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      gestures: {
        _DirectionalityDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<
                _DirectionalityDragGestureRecognizer>(
          () {
            final directionality = Directionality.of(context);
            return _DirectionalityDragGestureRecognizer(
              debugOwner: this,
              isRTL: directionality == TextDirection.rtl,
              isLTR: directionality == TextDirection.ltr,
              hasbackGestureController: () => _backGestureController != null,
              popGestureEnable: widget.popGestureEnable,
            );
          },
          (directionalityDragGesture) => directionalityDragGesture
            ..onStart = _handleDragStart
            ..onUpdate = _handleDragUpdate
            ..onEnd = _handleDragEnd
            ..onCancel = _handleDragCancel,
        )
      },
    );

    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        if (widget.limitedSwipe)
          PositionedDirectional(
            start: widget.initialOffset,
            width: _dragAreaWidth(context),
            top: 0,
            bottom: 0,
            child: gestureDetector,
          )
        else
          Positioned.fill(child: gestureDetector),
      ],
    );
  }

  double _dragAreaWidth(BuildContext context) {
    final dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? context.mediaQuery.padding.left
        : context.mediaQuery.padding.right;
    return max(dragAreaWidth, widget.gestureWidth);
  }
}
