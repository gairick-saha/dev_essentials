part of '../dev_snackbar.dart';

class DevEssentialSnackbar extends HookWidget {
  DevEssentialSnackbar({
    Key? key,
    this.title,
    this.message,
    this.titleText,
    this.messageText,
    this.icon,
    this.useAnimatedIcon = true,
    this.maxWidth,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 8.0,
    this.borderColor,
    this.borderWidth = 1.0,
    this.backgroundColor = const Color(0xFF303030),
    this.isDismissible = true,
    this.duration,
    this.mainButton,
    this.backgroundGradient,
    this.boxShadows,
    this.showProgressIndicator = false,
    this.progressIndicatorController,
    this.progressIndicatorBackgroundColor,
    this.progressIndicatorValueColor,
    this.leftBarIndicatorColor,
    this.blurValue = 0.0,
    this.overlayBlurValue = 0.0,
    this.overlayColor = Colors.transparent,
    this.userInputForm,
    this.position = DevEssentialSnackbarPosition.BOTTOM,
    this.style = DevEssentialSnackbarStyle.FLOATING,
    this.status,
    this.forwardAnimationCurve = Curves.easeOutCirc,
    this.reverseAnimationCurve = Curves.easeOutCirc,
    this.animationDuration = const Duration(seconds: 1),
    this.onTap,
    this.dismissDirection,
  })  : assert(
          message != null || (messageText != null && messageText.isNotEmpty),
          '''You need to either use messageText[String], or message[Widget] in DevEssentialSnackbar''',
        ),
        super(key: key);

  final Widget? title;
  final String? titleText;
  final Widget? message;
  final String? messageText;
  final Widget? icon;
  final bool useAnimatedIcon;
  final double? maxWidth;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final bool isDismissible;
  final Duration? duration;
  final Widget? mainButton;
  final Gradient? backgroundGradient;
  final List<BoxShadow>? boxShadows;
  final bool showProgressIndicator;
  final AnimationController? progressIndicatorController;
  final Color? progressIndicatorBackgroundColor;
  final Animation<Color>? progressIndicatorValueColor;
  final Color? leftBarIndicatorColor;

  /// Default is 0.0. If different than 0.0, blurs only Snack's background.
  /// To take effect, make sure your [backgroundColor] has some opacity.
  /// The greater the value, the greater the blur.
  final double blurValue;

  /// Default is 0.0. If different than 0.0, creates a blurred
  /// overlay that prevents the user from interacting with the screen.
  /// The greater the value, the greater the blur.
  final double overlayBlurValue;

  /// Default is [Colors.transparent]. Only takes effect if [overlayBlurValue] > 0.0.
  /// Make sure you use a color with transparency here e.g.
  /// Colors.grey[600].withOpacity(0.2).
  final Color? overlayColor;

  final DevEssentialReactiveFormBuilder? userInputForm;
  final DevEssentialSnackbarPosition position;
  final DevEssentialSnackbarStyle style;
  final DevEssentialSnackbarStatusCallback? status;
  final Curve forwardAnimationCurve;
  final Curve reverseAnimationCurve;
  final Duration animationDuration;

  /// A callback that registers the user's click anywhere.
  /// An alternative to [mainButton]
  final DevEssentialSnackbarOnTapCallback? onTap;

  /// The direction in which the SnackBar can be dismissed.
  ///
  /// Default is [DismissDirection.down] when
  /// [position] == [DevEssentialSnackbarPosition.BOTTOM] and [DismissDirection.up]
  /// when [position] == [DevEssentialSnackbarPosition.TOP]
  final DismissDirection? dismissDirection;

  @override
  Widget build(BuildContext context) {
    DevEssentialSnackbarHookState snackbarState = useDevEssentialSnackbarHook(
      progressIndicatorController: progressIndicatorController,
      showProgressIndicator: showProgressIndicator,
      configureIconAnimation: icon != null && icon is Icon && useAnimatedIcon,
      iconAnimationDuration: 1.seconds,
      iconAnimationFinalOpacity: 0.5,
      iconAnimationInitialOpacity: 1.0,
      hasTitle: title != null || titleText != null,
      padding: padding,
      margin: margin,
    );
    return Align(
      heightFactor: 1.0,
      child: Material(
        color: style == DevEssentialSnackbarStyle.FLOATING
            ? Colors.transparent
            : backgroundColor,
        child: SafeArea(
          minimum: position == DevEssentialSnackbarPosition.BOTTOM
              ? EdgeInsets.only(bottom: Dev.viewInsets.bottom)
              : EdgeInsets.only(top: Dev.mediaQuery.padding.top),
          bottom: position == DevEssentialSnackbarPosition.BOTTOM,
          top: position == DevEssentialSnackbarPosition.TOP,
          left: false,
          right: false,
          child: Stack(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [
              FutureBuilder<Size>(
                future: snackbarState._boxHeightCompleter.future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (blurValue == 0) {
                      return _emptyWidget;
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: blurValue,
                          sigmaY: blurValue,
                        ),
                        child: Container(
                          height: snapshot.data!.height,
                          width: snapshot.data!.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return _emptyWidget;
                  }
                },
              ),
              if (userInputForm == null)
                _containerWithoutForm(context, snackbarState)
              else
                _containerWithForm(context, snackbarState),
            ],
          ),
        ),
      ),
    );
  }

  double get buttonPadding {
    if (padding.right - 12 < 0) {
      return 4;
    } else {
      return padding.right - 12;
    }
  }

  DevEssentialSnackbarRowStyle get _rowStyle {
    if (mainButton != null && icon == null) {
      return DevEssentialSnackbarRowStyle.action;
    } else if (mainButton == null && icon != null) {
      return DevEssentialSnackbarRowStyle.icon;
    } else if (mainButton != null && icon != null) {
      return DevEssentialSnackbarRowStyle.all;
    } else {
      return DevEssentialSnackbarRowStyle.none;
    }
  }

  final Widget _emptyWidget = const SizedBox.shrink();

  Widget? _getIcon(
    BuildContext context,
    DevEssentialSnackbarHookState snackbarState,
  ) {
    if (icon != null && icon is Icon && useAnimatedIcon) {
      return FadeTransition(
        opacity: snackbarState._iconFadeAnimation,
        child: icon,
      );
    } else if (icon != null) {
      return icon;
    }

    return null;
  }

  Widget _buildLeftBarIndicator(
    BuildContext context,
    DevEssentialSnackbarHookState snackbarState,
  ) {
    if (leftBarIndicatorColor != null) {
      return FutureBuilder<Size>(
        future: snackbarState._boxHeightCompleter.future,
        builder: (buildContext, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: leftBarIndicatorColor,
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

  Widget _containerWithoutForm(
    BuildContext context,
    DevEssentialSnackbarHookState snackbarState,
  ) {
    final iconPadding = padding.left > 16.0 ? padding.left : 0.0;
    final left = _rowStyle == DevEssentialSnackbarRowStyle.icon ||
            _rowStyle == DevEssentialSnackbarRowStyle.all
        ? 4.0
        : padding.left;
    final right = _rowStyle == DevEssentialSnackbarRowStyle.action ||
            _rowStyle == DevEssentialSnackbarRowStyle.all
        ? 8.0
        : padding.right;

    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      constraints:
          maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: backgroundGradient,
        boxShadow: boxShadows,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showProgressIndicator
              ? LoadingIndictor(
                  materialLoadingValue: progressIndicatorController != null
                      ? snackbarState._progressAnimation.value
                      : null,
                  materialLoadingBackgroundColor:
                      progressIndicatorBackgroundColor,
                  materialLoadingValueColor: progressIndicatorValueColor,
                )
              : _emptyWidget,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildLeftBarIndicator(context, snackbarState),
              if (_rowStyle == DevEssentialSnackbarRowStyle.icon ||
                  _rowStyle == DevEssentialSnackbarRowStyle.all)
                ConstrainedBox(
                  constraints:
                      BoxConstraints.tightFor(width: 42.0 + iconPadding),
                  child: _getIcon(context, snackbarState),
                ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (snackbarState._isTitlePresent)
                      Padding(
                        padding: EdgeInsets.only(
                          top: padding.top,
                          left: left,
                          right: right,
                        ),
                        child: title ??
                            Text(
                              titleText ?? "",
                              textScaleFactor: Dev.textScaleFactor,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: snackbarState._messageTopMargin,
                        left: left,
                        right: right,
                        bottom: padding.bottom,
                      ),
                      child: message ??
                          Text(
                            messageText ?? "",
                            textScaleFactor: Dev.textScaleFactor,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                          ),
                    ),
                  ],
                ),
              ),
              if (_rowStyle == DevEssentialSnackbarRowStyle.action ||
                  _rowStyle == DevEssentialSnackbarRowStyle.all)
                Padding(
                  padding: EdgeInsets.only(right: buttonPadding),
                  child: mainButton,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _containerWithForm(
    BuildContext context,
    DevEssentialSnackbarHookState snackbarState,
  ) {
    return Container(
      key: snackbarState._backgroundBoxKey,
      constraints:
          maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: backgroundGradient,
        boxShadow: boxShadows,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth,
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
        child: FocusScope(
          node: snackbarState._userInputFormFocusNode,
          autofocus: true,
          child: userInputForm!,
        ),
      ),
    );
  }
}
