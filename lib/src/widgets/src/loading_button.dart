part of '../widgets.dart';

typedef DevEssentialLoadingButtonType = LoadingButtonType;

class DevEssentialLoadingButton extends HookWidget {
  const DevEssentialLoadingButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.color,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.radius = 8,
    this.buttonTextstyle,
    this.loadingWidget,
    this.animate = true,
    this.type = DevEssentialLoadingButtonType.Elevated,
    this.borderSide = BorderSide.none,
    this.padding,
    this.hideBackgroundDuringLoading = true,
  })  : child = null,
        super(key: key);

  const DevEssentialLoadingButton.custom({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
    this.borderColor,
    this.width,
    this.height,
    this.radius = 8,
    this.loadingWidget,
    this.animate = true,
    this.type = DevEssentialLoadingButtonType.Elevated,
    this.borderSide = BorderSide.none,
    this.padding,
    this.hideBackgroundDuringLoading = true,
  })  : buttonText = null,
        buttonTextstyle = null,
        textColor = null,
        super(key: key);

  final String? buttonText;
  final Widget? child;
  final Future<void> Function() onPressed;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double radius;
  final TextStyle? buttonTextstyle;
  final Widget? loadingWidget;
  final bool animate;
  final LoadingButtonType type;
  final BorderSide borderSide;
  final EdgeInsetsGeometry? padding;
  final bool hideBackgroundDuringLoading;

  @override
  Widget build(BuildContext context) {
    final Color defaultButtonColor =
        color ?? Theme.of(context).colorScheme.primary;
    final Color? defaultTextColor = textColor;
    final ValueNotifier<Color> buttonColor =
        useState<Color>(defaultButtonColor);

    return LoadingButton(
      defaultWidget: child ??
          Text(
            buttonText!,
            // textScaleFactor: Dev.textScaleFactor,
            style: buttonTextstyle?.copyWith(color: defaultTextColor),
          ),
      loadingWidget: loadingWidget ?? LoadingIndictor(color: defaultTextColor),
      color: buttonColor.value,
      borderRadius: radius,
      height: height ?? kMinInteractiveDimension,
      width: width,
      onPressed: () async {
        if (hideBackgroundDuringLoading) {
          buttonColor.value = Colors.transparent;
          await onPressed().whenComplete(
            () => buttonColor.value = defaultButtonColor,
          );
        } else {
          await onPressed();
        }
      },
      animate: animate,
      type: type,
      borderSide: borderSide.copyWith(
        color: borderColor ?? defaultButtonColor,
      ),
      padding: padding,
      textcolor: textColor,
    );
  }
}
