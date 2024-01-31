part of '../snackbar.dart';

class DevEssentialSnackBar extends StatefulWidget {
  final SnackbarStatusCallback? snackbarStatus;

  final String? title;

  final DismissDirection? dismissDirection;

  final String? message;

  final Widget? titleText;

  final Widget? messageText;

  final Color backgroundColor;

  final Color? leftBarIndicatorColor;

  final List<BoxShadow>? boxShadows;

  final Gradient? backgroundGradient;

  final Widget? icon;

  final bool shouldIconPulse;

  final Widget? mainButton;

  final OnSnackbarTap? onTap;

  final OnSnackbarHover? onHover;

  final Duration? duration;

  final bool showProgressIndicator;

  final AnimationController? progressIndicatorController;

  final Color? progressIndicatorBackgroundColor;

  final Animation<Color>? progressIndicatorValueColor;

  final bool isDismissible;

  final double? maxWidth;

  final EdgeInsets margin;

  final EdgeInsets padding;

  final double borderRadius;

  final Color? borderColor;

  final double? borderWidth;

  final SnackPosition snackPosition;

  final SnackStyle snackStyle;

  final Curve forwardAnimationCurve;

  final Curve reverseAnimationCurve;

  final Duration animationDuration;

  final double barBlur;

  final double overlayBlur;

  final Color? overlayColor;

  final Form? userInputForm;

  const DevEssentialSnackBar({
    Key? key,
    this.title,
    this.message,
    this.titleText,
    this.messageText,
    this.icon,
    this.shouldIconPulse = true,
    this.maxWidth,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 0.0,
    this.borderColor,
    this.borderWidth = 1.0,
    this.backgroundColor = const Color(0xFF303030),
    this.leftBarIndicatorColor,
    this.boxShadows,
    this.backgroundGradient,
    this.mainButton,
    this.onTap,
    this.onHover,
    this.duration,
    this.isDismissible = true,
    this.dismissDirection,
    this.showProgressIndicator = false,
    this.progressIndicatorController,
    this.progressIndicatorBackgroundColor,
    this.progressIndicatorValueColor,
    this.snackPosition = SnackPosition.bottom,
    this.snackStyle = SnackStyle.floating,
    this.forwardAnimationCurve = Curves.easeOutCirc,
    this.reverseAnimationCurve = Curves.easeOutCirc,
    this.animationDuration = const Duration(seconds: 1),
    this.barBlur = 0.0,
    this.overlayBlur = 0.0,
    this.overlayColor = Colors.transparent,
    this.userInputForm,
    this.snackbarStatus,
  }) : super(key: key);

  @override
  State createState() => DevEssentialSnackBarState();

  DevEssentialSnackbarController show() => Dev.showSnackbar(this);
}

class DevEssentialSnackBarState extends State<DevEssentialSnackBar>
    with TickerProviderStateMixin {
  AnimationController? _fadeController;
  late Animation<double> _fadeAnimation;

  final Widget _emptyWidget = const SizedBox(width: 0.0, height: 0.0);
  final double _initialOpacity = 1.0;
  final double _finalOpacity = 0.4;

  final Duration _pulseAnimationDuration = const Duration(seconds: 1);

  late bool _isTitlePresent;
  late double _messageTopMargin;

  FocusScopeNode? _focusNode;
  late FocusAttachment _focusAttachment;

  final Completer<Size> _boxHeightCompleter = Completer<Size>();

  late CurvedAnimation _progressAnimation;

  final _backgroundBoxKey = GlobalKey();

  double get buttonPadding {
    if (widget.padding.right - 12 < 0) {
      return 4;
    } else {
      return widget.padding.right - 12;
    }
  }

  RowStyle get _rowStyle {
    if (widget.mainButton != null && widget.icon == null) {
      return RowStyle.action;
    } else if (widget.mainButton == null && widget.icon != null) {
      return RowStyle.icon;
    } else if (widget.mainButton != null && widget.icon != null) {
      return RowStyle.all;
    } else {
      return RowStyle.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 1.0,
      child: Material(
        color: widget.snackStyle == SnackStyle.floating
            ? Colors.transparent
            : widget.backgroundColor,
        child: SafeArea(
          minimum: widget.snackPosition == SnackPosition.bottom
              ? EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)
              : EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          bottom: widget.snackPosition == SnackPosition.bottom,
          top: widget.snackPosition == SnackPosition.top,
          left: false,
          right: false,
          child: Stack(
            children: [
              FutureBuilder<Size>(
                future: _boxHeightCompleter.future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (widget.barBlur == 0) {
                      return _emptyWidget;
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: widget.barBlur, sigmaY: widget.barBlur),
                        child: Container(
                          height: snapshot.data!.height,
                          width: snapshot.data!.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return _emptyWidget;
                  }
                },
              ),
              if (widget.userInputForm != null)
                _containerWithForm()
              else
                _containerWithoutForm()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    widget.progressIndicatorController?.removeListener(_updateProgress);
    widget.progressIndicatorController?.dispose();

    _focusAttachment.detach();
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    assert(
      widget.userInputForm != null ||
          ((widget.message != null && widget.message!.isNotEmpty) ||
              widget.messageText != null),
      '''You need to either use message[String], or messageText[Widget] or define a userInputForm[Form] in DevEssentialSnackbar''',
    );
    _isTitlePresent = (widget.title != null || widget.titleText != null);
    _messageTopMargin = _isTitlePresent ? 6.0 : widget.padding.top;

    _configureLeftBarFuture();
    _configureProgressIndicatorAnimation();

    if (widget.icon != null && widget.shouldIconPulse) {
      _configurePulseAnimation();
      _fadeController?.forward();
    }

    _focusNode = FocusScopeNode();
    _focusAttachment = _focusNode!.attach(context);
  }

  Widget _buildLeftBarIndicator() {
    if (widget.leftBarIndicatorColor != null) {
      return FutureBuilder<Size>(
        future: _boxHeightCompleter.future,
        builder: (buildContext, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: widget.leftBarIndicatorColor,
              width: 5.0,
              height: snapshot.data!.height,
            );
          } else {
            return _emptyWidget;
          }
        },
      );
    } else {
      return _emptyWidget;
    }
  }

  void _configureLeftBarFuture() {
    Engine.instance.addPostFrameCallback(
      (_) {
        final keyContext = _backgroundBoxKey.currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox;
          _boxHeightCompleter.complete(box.size);
        }
      },
    );
  }

  void _configureProgressIndicatorAnimation() {
    if (widget.showProgressIndicator &&
        widget.progressIndicatorController != null) {
      widget.progressIndicatorController!.addListener(_updateProgress);

      _progressAnimation = CurvedAnimation(
          curve: Curves.linear, parent: widget.progressIndicatorController!);
    }
  }

  void _configurePulseAnimation() {
    _fadeController =
        AnimationController(vsync: this, duration: _pulseAnimationDuration);
    _fadeAnimation = Tween(begin: _initialOpacity, end: _finalOpacity).animate(
      CurvedAnimation(
        parent: _fadeController!,
        curve: Curves.linear,
      ),
    );

    _fadeController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController!.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        _fadeController!.forward();
      }
    });

    _fadeController!.forward();
  }

  Widget _containerWithForm() {
    return Container(
      key: _backgroundBoxKey,
      constraints: widget.maxWidth != null
          ? BoxConstraints(maxWidth: widget.maxWidth!)
          : null,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.backgroundGradient,
        boxShadow: widget.boxShadows,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.borderColor != null
            ? Border.all(
                color: widget.borderColor!,
                width: widget.borderWidth!,
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
        child: FocusScope(
          node: _focusNode,
          autofocus: true,
          child: widget.userInputForm!,
        ),
      ),
    );
  }

  Widget _containerWithoutForm() {
    final iconPadding = widget.padding.left > 16.0 ? widget.padding.left : 0.0;
    final left = _rowStyle == RowStyle.icon || _rowStyle == RowStyle.all
        ? 4.0
        : widget.padding.left;
    final right = _rowStyle == RowStyle.action || _rowStyle == RowStyle.all
        ? 8.0
        : widget.padding.right;
    return Container(
      key: _backgroundBoxKey,
      constraints: widget.maxWidth != null
          ? BoxConstraints(maxWidth: widget.maxWidth!)
          : null,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.backgroundGradient,
        boxShadow: widget.boxShadows,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!, width: widget.borderWidth!)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.showProgressIndicator
              ? LinearProgressIndicator(
                  value: widget.progressIndicatorController != null
                      ? _progressAnimation.value
                      : null,
                  backgroundColor: widget.progressIndicatorBackgroundColor,
                  valueColor: widget.progressIndicatorValueColor,
                )
              : _emptyWidget,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildLeftBarIndicator(),
              if (_rowStyle == RowStyle.icon || _rowStyle == RowStyle.all)
                ConstrainedBox(
                  constraints:
                      BoxConstraints.tightFor(width: 42.0 + iconPadding),
                  child: _getIcon(),
                ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (_isTitlePresent)
                      Padding(
                        padding: EdgeInsets.only(
                          top: widget.padding.top,
                          left: left,
                          right: right,
                        ),
                        child: widget.titleText ??
                            Text(
                              widget.title ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      )
                    else
                      _emptyWidget,
                    Padding(
                      padding: EdgeInsets.only(
                        top: _messageTopMargin,
                        left: left,
                        right: right,
                        bottom: widget.padding.bottom,
                      ),
                      child: widget.messageText ??
                          Text(
                            widget.message ?? "",
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.white),
                          ),
                    ),
                  ],
                ),
              ),
              if (_rowStyle == RowStyle.action || _rowStyle == RowStyle.all)
                Padding(
                  padding: EdgeInsets.only(right: buttonPadding),
                  child: widget.mainButton,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? _getIcon() {
    if (widget.icon != null && widget.icon is Icon && widget.shouldIconPulse) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: widget.icon,
      );
    } else if (widget.icon != null) {
      return widget.icon;
    } else {
      return _emptyWidget;
    }
  }

  void _updateProgress() => setState(() {});
}
