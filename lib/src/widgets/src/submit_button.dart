part of '../widgets.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.radius = 8,
    this.buttonTextstyle,
    this.loadingWidget,
    this.animate = true,
  })  : child = null,
        super(key: key);

  const SubmitButton.custom({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.radius = 8,
    this.loadingWidget,
    this.animate = true,
  })  : buttonText = null,
        buttonTextstyle = null,
        textColor = null,
        super(key: key);

  final String? buttonText;
  final Widget? child;
  final Future<void> Function() onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double radius;
  final TextStyle? buttonTextstyle;
  final Widget? loadingWidget;
  final bool animate;

  @override
  Widget build(BuildContext context) => LoadingButton(
        defaultWidget: child ??
            Text(
              buttonText!,
              style: buttonTextstyle?.copyWith(color: textColor),
            ),
        loadingWidget: loadingWidget ?? LoadingIndictor(color: textColor),
        color: color,
        borderRadius: radius,
        height: height ?? kMinInteractiveDimension,
        width: width,
        onPressed: onPressed,
        animate: animate,
      );
}
