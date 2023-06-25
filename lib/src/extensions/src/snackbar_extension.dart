part of '../extensions.dart';

extension ExtensionSnackbar on DevEssential {
  DevEssentialSnackbarController showDefaultSnackbar({
    Widget? title,
    Widget? message,
    String? titleText,
    String? messageText,
    Widget? icon,
    bool instantInit = true,
    bool useAnimatedIcon = true,
    double? maxWidth,
    EdgeInsets margin = const EdgeInsets.all(0.0),
    EdgeInsets padding = const EdgeInsets.all(16),
    double borderRadius = 0.0,
    Color? borderColor,
    double borderWidth = 1.0,
    Color backgroundColor = const Color(0xFF303030),
    Color? leftBarIndicatorColor,
    List<BoxShadow>? boxShadows,
    Gradient? backgroundGradient,
    Widget? mainButton,
    DevEssentialSnackbarOnTapCallback? onTap,
    Duration? duration = const Duration(seconds: 3),
    bool isDismissible = true,
    DismissDirection? dismissDirection,
    bool showProgressIndicator = false,
    AnimationController? progressIndicatorController,
    Color? progressIndicatorBackgroundColor,
    Animation<Color>? progressIndicatorValueColor,
    DevEssentialSnackbarPosition position = DevEssentialSnackbarPosition.BOTTOM,
    DevEssentialSnackbarStyle style = DevEssentialSnackbarStyle.FLOATING,
    Curve forwardAnimationCurve = Curves.easeOutCirc,
    Curve reverseAnimationCurve = Curves.easeOutCirc,
    Duration animationDuration = const Duration(seconds: 1),
    DevEssentialSnackbarStatusCallback? snackbarStatus,
    double blurValue = 0.0,
    double overlayBlurValue = 0.0,
    Color? overlayColor,
    DevEssentialFormBuilder? userInputForm,
  }) {
    final DevEssentialSnackbar newSnackbar = DevEssentialSnackbar(
      status: snackbarStatus,
      title: title,
      message: message,
      titleText: titleText,
      messageText: messageText,
      position: position,
      borderRadius: borderRadius,
      margin: margin,
      padding: padding,
      duration: duration,
      blurValue: blurValue,
      backgroundColor: backgroundColor,
      icon: icon,
      useAnimatedIcon: useAnimatedIcon,
      maxWidth: maxWidth,
      borderColor: borderColor,
      borderWidth: borderWidth,
      leftBarIndicatorColor: leftBarIndicatorColor,
      boxShadows: boxShadows,
      backgroundGradient: backgroundGradient,
      mainButton: mainButton,
      onTap: onTap,
      isDismissible: isDismissible,
      dismissDirection: dismissDirection,
      showProgressIndicator: showProgressIndicator,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
      progressIndicatorValueColor: progressIndicatorValueColor,
      style: style,
      forwardAnimationCurve: forwardAnimationCurve,
      reverseAnimationCurve: reverseAnimationCurve,
      animationDuration: animationDuration,
      overlayBlurValue: overlayBlurValue,
      overlayColor: overlayColor,
      userInputForm: userInputForm,
    );

    final DevEssentialSnackbarController controller =
        DevEssentialSnackbarController(newSnackbar);

    if (instantInit) {
      controller.show();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) => controller.show());
    }
    return controller;
  }

  DevEssentialSnackbarController showCustomSnackbar(
      DevEssentialSnackbar snackbar) {
    final DevEssentialSnackbarController controller =
        DevEssentialSnackbarController(snackbar);
    controller.show();
    return controller;
  }

  DevEssentialSnackbarController showSnackbar({
    required String titleText,
    required String messageText,
    Color? colorText,
    Duration? duration = const Duration(seconds: 3),
    bool instantInit = true,
    DevEssentialSnackbarPosition? position,
    Widget? title,
    Widget? message,
    Widget? icon,
    bool? useAnimatedIcon,
    double? maxWidth,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? backgroundColor,
    Color? leftBarIndicatorColor,
    List<BoxShadow>? boxShadows,
    Gradient? backgroundGradient,
    TextButton? mainButton,
    DevEssentialSnackbarOnTapCallback? onTap,
    bool? isDismissible,
    bool? showProgressIndicator,
    DismissDirection? dismissDirection,
    AnimationController? progressIndicatorController,
    Color? progressIndicatorBackgroundColor,
    Animation<Color>? progressIndicatorValueColor,
    DevEssentialSnackbarStyle? style,
    Curve? forwardAnimationCurve,
    Curve? reverseAnimationCurve,
    Duration? animationDuration,
    double? blurValue,
    double? overlayBlurValue,
    DevEssentialSnackbarStatusCallback? status,
    Color? overlayColor,
    DevEssentialFormBuilder? userInputForm,
  }) {
    backgroundColor ??= Dev.theme.colorScheme.primary.withOpacity(0.4);
    blurValue ??= 7.0;

    final DevEssentialSnackbar getSnackBar = DevEssentialSnackbar(
      status: status,
      titleText: titleText,
      title: title,
      message: message,
      messageText: messageText,
      position: position ?? DevEssentialSnackbarPosition.BOTTOM,
      borderRadius: borderRadius ?? 15,
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: Dev.mediaQuery.viewPadding.bottom + 12.0,
          ),
      padding: padding ?? const EdgeInsets.all(16),
      duration: duration,
      blurValue: blurValue,
      backgroundColor: backgroundColor,
      icon: icon,
      useAnimatedIcon: useAnimatedIcon ?? true,
      maxWidth: maxWidth,
      borderColor: borderColor,
      borderWidth: borderWidth ?? 1.0,
      leftBarIndicatorColor: leftBarIndicatorColor,
      boxShadows: boxShadows,
      backgroundGradient: backgroundGradient,
      mainButton: mainButton,
      onTap: onTap,
      isDismissible: isDismissible ?? true,
      dismissDirection: dismissDirection,
      showProgressIndicator: showProgressIndicator ?? false,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
      progressIndicatorValueColor: progressIndicatorValueColor,
      style: style ?? DevEssentialSnackbarStyle.FLOATING,
      forwardAnimationCurve: forwardAnimationCurve ?? Curves.easeOutCirc,
      reverseAnimationCurve: reverseAnimationCurve ?? Curves.easeOutCirc,
      animationDuration: animationDuration ?? const Duration(seconds: 1),
      overlayBlurValue: overlayBlurValue ?? 0.0,
      overlayColor: overlayColor ?? Colors.transparent,
      userInputForm: userInputForm,
    );

    final DevEssentialSnackbarController controller =
        DevEssentialSnackbarController(getSnackBar);

    if (instantInit) {
      controller.show();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) => controller.show());
    }
    return controller;
  }
}
