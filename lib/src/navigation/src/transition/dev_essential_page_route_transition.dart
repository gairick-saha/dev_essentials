part of '../../navigation.dart';

typedef GestureWidthCallback = double Function(BuildContext context);

mixin DevEssentialPageRouteTransitionMixin<T> on PageRoute<T> {
  @override
  Color? get barrierColor;

  @override
  String? get barrierLabel;

  @override
  Duration get transitionDuration;

  @override
  Duration get reverseTransitionDuration;

  String? get title;

  GestureWidthCallback? get gestureWidth;

  ValueNotifier<String?>? _previousTitle;

  ValueListenable<String?> get previousTitle {
    assert(
      _previousTitle != null,
      '''Cannot read the previousTitle for a route that has not yet been installed''',
    );
    return _previousTitle!;
  }

  bool get showCupertinoParallax;

  @protected
  Widget buildContent(BuildContext context);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final child = buildContent(context);
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
    return result;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return (nextRoute is DevEssentialPageRouteTransitionMixin &&
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

  static bool canSwipe(DevEssentialPageRoute route) =>
      route.popGesture ?? DevEssentialPlatform.isIOS;

  static bool isPopGestureInProgress(BuildContext context) {
    final route = ModalRoute.of(context)!;
    return route.navigator!.userGestureInProgress;
  }

  static bool _isPopGestureEnabled<T>(
    PageRoute<T> route,
    bool canSwipe,
    BuildContext context,
  ) {
    if (route.isFirst) return false;

    if (route.willHandlePopInternally) return false;

    // ignore: deprecated_member_use
    if (route.hasScopedWillPopCallback) return false;

    if (route.fullscreenDialog) return false;

    if (route.animation!.status != AnimationStatus.completed) return false;

    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }

    if (DevEssentialPageRouteTransitionMixin.isPopGestureInProgress(context)) {
      return false;
    }

    if (!canSwipe) return false;

    return true;
  }

  static DevEssentialBackGestureController<T> _startPopGesture<T>(
    PageRoute<T> route,
  ) {
    return DevEssentialBackGestureController<T>(
      navigator: route.navigator!,
      controller: route.controller!,
    );
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

  static Widget buildPageTransitions<T>(
    PageRoute<T> rawRoute,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    bool limitedSwipe = false,
    double initialOffset = 0,
  }) {
    final route = rawRoute as DevEssentialPageRoute<T>;
    final linearTransition =
        CupertinoRouteTransitionMixin.isPopGestureInProgress(route);
    final finalCurve = route.curve ?? Dev.defaultTransitionCurve;
    final hasCurve = route.curve != null;
    if (route.fullscreenDialog && route.transition == null) {
      return CupertinoFullscreenDialogTransition(
        primaryRouteAnimation: hasCurve
            ? CurvedAnimation(parent: animation, curve: finalCurve)
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
          route.alignment,
          animation,
          secondaryAnimation,
          DevEssentialBackGestureDetector<T>(
            popGestureEnable: () =>
                _isPopGestureEnabled(route, canSwipe(route), context),
            onStartPopGesture: () {
              assert(_isPopGestureEnabled(route, canSwipe(route), context));
              return _startPopGesture(route);
            },
            limitedSwipe: limitedSwipe,
            gestureWidth:
                route.gestureWidth?.call(context) ?? _kBackGestureWidth,
            initialOffset: initialOffset,
            child: child,
          ),
        );
      }

      final iosAnimation = animation;
      animation = CurvedAnimation(parent: animation, curve: finalCurve);

      switch (route.transition ?? Dev.defaultTransition) {
        case DevEssentialTransition.leftToRight:
          return SlideLeftTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.downToUp:
          return SlideDownTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.upToDown:
          return SlideTopTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.noTransition:
          return DevEssentialBackGestureDetector<T>(
            popGestureEnable: () =>
                _isPopGestureEnabled(route, canSwipe(route), context),
            onStartPopGesture: () {
              assert(_isPopGestureEnabled(route, canSwipe(route), context));
              return _startPopGesture(route);
            },
            limitedSwipe: limitedSwipe,
            gestureWidth:
                route.gestureWidth?.call(context) ?? _kBackGestureWidth,
            initialOffset: initialOffset,
            child: child,
          );

        case DevEssentialTransition.rightToLeft:
          return SlideRightTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.zoom:
          return ZoomInTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.fadeIn:
          return FadeInTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.rightToLeftWithFade:
          return RightToLeftFadeTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.leftToRightWithFade:
          return LeftToRightFadeTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.cupertino:
          return CupertinoPageTransition(
              primaryRouteAnimation: animation,
              secondaryRouteAnimation: secondaryAnimation,
              linearTransition: linearTransition,
              child: DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.size:
          return SizeTransitions().buildTransitions(
              context,
              route.curve!,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.fade:
          return const FadeUpwardsPageTransitionsBuilder().buildTransitions(
              route,
              context,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.topLevel:
          return const ZoomPageTransitionsBuilder().buildTransitions(
              route,
              context,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.native:
          return const PageTransitionsTheme().buildTransitions(
              route,
              context,
              iosAnimation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        case DevEssentialTransition.circularReveal:
          return CircularRevealTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(_isPopGestureEnabled(route, canSwipe(route), context));
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));

        default:
          final customTransition = Dev.of(context).config.customTransition;

          if (customTransition != null) {
            return customTransition.buildTransition(context, route.curve,
                route.alignment, animation, secondaryAnimation, child);
          }

          PageTransitionsTheme pageTransitionsTheme =
              Theme.of(context).pageTransitionsTheme;

          return pageTransitionsTheme.buildTransitions(
              route,
              context,
              iosAnimation,
              secondaryAnimation,
              DevEssentialBackGestureDetector<T>(
                popGestureEnable: () =>
                    _isPopGestureEnabled(route, canSwipe(route), context),
                onStartPopGesture: () {
                  assert(
                    _isPopGestureEnabled(route, canSwipe(route), context),
                  );
                  return _startPopGesture(route);
                },
                limitedSwipe: limitedSwipe,
                gestureWidth:
                    route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                initialOffset: initialOffset,
                child: child,
              ));
      }
    }
  }
}
