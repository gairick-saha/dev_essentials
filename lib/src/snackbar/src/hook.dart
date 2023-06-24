part of '../dev_snackbar.dart';

DevEssentialSnackbarHookState useDevEssentialSnackbarHook({
  required bool showProgressIndicator,
  required AnimationController? progressIndicatorController,
  required bool configureIconAnimation,
  required Duration iconAnimationDuration,
  required double iconAnimationInitialOpacity,
  required double iconAnimationFinalOpacity,
  required bool hasTitle,
  required EdgeInsets margin,
  required EdgeInsets padding,
}) {
  final TickerProvider animatedIconVsync = useSingleTickerProvider();
  return use(DevEssentialSnackbarHook(
    animatedIconVsync: animatedIconVsync,
    showProgressIndicator: showProgressIndicator,
    progressIndicatorController: progressIndicatorController,
    configureIconAnimation: configureIconAnimation,
    iconAnimationDuration: iconAnimationDuration,
    iconAnimationInitialOpacity: iconAnimationInitialOpacity,
    iconAnimationFinalOpacity: iconAnimationFinalOpacity,
    hasTitle: hasTitle,
    margin: margin,
    padding: padding,
  ));
}

class DevEssentialSnackbarHook extends Hook<DevEssentialSnackbarHookState> {
  const DevEssentialSnackbarHook({
    required this.animatedIconVsync,
    required this.showProgressIndicator,
    required this.progressIndicatorController,
    required this.configureIconAnimation,
    required this.iconAnimationDuration,
    required this.iconAnimationInitialOpacity,
    required this.iconAnimationFinalOpacity,
    required this.hasTitle,
    required this.margin,
    required this.padding,
  });

  final TickerProvider animatedIconVsync;
  final bool showProgressIndicator;
  final AnimationController? progressIndicatorController;
  final bool configureIconAnimation;
  final Duration iconAnimationDuration;
  final double iconAnimationInitialOpacity;
  final double iconAnimationFinalOpacity;
  final bool hasTitle;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  HookState<DevEssentialSnackbarHookState, Hook<DevEssentialSnackbarHookState>>
      createState() => DevEssentialSnackbarHookState();
}

class DevEssentialSnackbarHookState
    extends HookState<DevEssentialSnackbarHookState, DevEssentialSnackbarHook> {
  late CurvedAnimation _progressAnimation;

  final GlobalKey _backgroundBoxKey = GlobalKey();
  final Completer<Size> _boxHeightCompleter = Completer<Size>();

  late bool _isTitlePresent;
  late double _messageTopMargin;

  AnimationController? _iconFadeController;
  late Animation<double> _iconFadeAnimation;

  FocusScopeNode? _userInputFormFocusNode;
  late FocusAttachment _userInputFocusAttachment;

  @override
  void initHook() {
    _isTitlePresent = hook.hasTitle;
    _messageTopMargin = _isTitlePresent ? 6.0 : hook.padding.top;

    _configureLeftBarFuture();
    _configureProgressIndicatorAnimation();
    if (hook.configureIconAnimation) {
      _configureIconAnimation();
      _iconFadeController?.forward();
    }

    _userInputFormFocusNode = FocusScopeNode();
    _userInputFocusAttachment = _userInputFormFocusNode!.attach(context);

    super.initHook();
  }

  void _configureIconAnimation() {
    _iconFadeController = AnimationController(
      vsync: hook.animatedIconVsync,
      duration: hook.iconAnimationDuration,
    );
    _iconFadeAnimation = Tween<double>(
      begin: hook.iconAnimationInitialOpacity,
      end: hook.iconAnimationFinalOpacity,
    ).animate(
      CurvedAnimation(
        parent: _iconFadeController!,
        curve: Curves.linear,
      ),
    );

    _iconFadeController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _iconFadeController!.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        _iconFadeController!.forward();
      }
    });

    _iconFadeController!.forward();
  }

  void _configureLeftBarFuture() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        final BuildContext? keyContext = _backgroundBoxKey.currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox;
          _boxHeightCompleter.complete(box.size);
        }
      },
    );
  }

  void _configureProgressIndicatorAnimation() {
    if (hook.showProgressIndicator &&
        hook.progressIndicatorController != null) {
      hook.progressIndicatorController!
          .addListener(_updateProgressIndicatorValue);

      _progressAnimation = CurvedAnimation(
        curve: Curves.linear,
        parent: hook.progressIndicatorController!,
      );
    }
  }

  void _updateProgressIndicatorValue() => setState(() {});

  @override
  void dispose() {
    _iconFadeController?.dispose();
    hook.progressIndicatorController
        ?.removeListener(_updateProgressIndicatorValue);
    hook.progressIndicatorController?.dispose();
    _userInputFocusAttachment.detach();
    _userInputFormFocusNode!.dispose();
    super.dispose();
  }

  @override
  DevEssentialSnackbarHookState build(BuildContext context) => this;
}
