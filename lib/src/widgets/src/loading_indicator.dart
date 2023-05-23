part of '../widgets.dart';

class LoadingIndictor extends StatelessWidget {
  const LoadingIndictor({
    Key? key,
    this.materialLoadingValue,
    this.materialLoadingBackgroundColor,
    this.color,
    this.materialLoadingValueColor,
    this.materialLoadingStrokeWidth = 4.0,
    this.materialLoadingSemanticsLabel,
    this.materialLoadingSemanticsValue,
    this.isCupertionAnimating = true,
    this.cupertionLoadingRadius = 10.0,
  }) : super(key: key);

  final double? materialLoadingValue;
  final Color? materialLoadingBackgroundColor;
  final Color? color;
  final Animation<Color?>? materialLoadingValueColor;
  final double materialLoadingStrokeWidth;
  final String? materialLoadingSemanticsLabel;
  final String? materialLoadingSemanticsValue;
  final bool isCupertionAnimating;
  final double cupertionLoadingRadius;

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isIOS
        ? CupertinoActivityIndicator(
            key: key,
            color: color,
            animating: isCupertionAnimating,
            radius: cupertionLoadingRadius,
          )
        : CircularProgressIndicator(
            key: key,
            color: color,
            value: materialLoadingValue,
            backgroundColor: materialLoadingBackgroundColor,
            valueColor: materialLoadingValueColor,
            strokeWidth: materialLoadingStrokeWidth,
            semanticsLabel: materialLoadingSemanticsLabel,
            semanticsValue: materialLoadingSemanticsValue,
          );
  }
}
