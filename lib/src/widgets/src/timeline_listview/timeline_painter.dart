part of '../../widgets.dart';

abstract class _TimelinePainter extends BoxPainter {
  final Paint linePaint;
  final Paint circlePaint;
  final double iconSize;
  final bool isFirst;
  final bool isLast;
  final Color lineColor;
  final double lineWidth;
  final double timelinewidth;
  final bool hasIcon;
  final TextPainter? labelTextPainter;
  final Widget? icon;

  _TimelinePainter(
    super.onChanged, {
    required this.iconSize,
    required this.lineColor,
    required this.lineWidth,
    required this.timelinewidth,
    required this.isFirst,
    required this.isLast,
    required this.hasIcon,
    required this.labelTextPainter,
    required this.icon,
    iconBackground,
  })  : linePaint = Paint()
          ..color = lineColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke,
        circlePaint = Paint()
          ..color = iconBackground ?? Dev.theme.colorScheme.primary
          ..style = PaintingStyle.fill;
}

class _TimelineDecoration extends Decoration {
  const _TimelineDecoration({
    required this.iconSize,
    required this.isFirst,
    required this.isLast,
    required this.lineColor,
    required this.lineWidth,
    required this.timelinewidth,
    required this.hasIcon,
    required this.labelTextPainter,
    required this.icon,
  });

  final double iconSize;
  final bool isFirst;
  final bool isLast;
  final Color lineColor;
  final double lineWidth;
  final double timelinewidth;
  final bool hasIcon;
  final TextPainter? labelTextPainter;
  final Widget? icon;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _LeftTimelinePainter(
      onChanged,
      iconSize: iconSize,
      lineColor: lineColor,
      lineWidth: lineWidth,
      timelinewidth: timelinewidth,
      isFirst: isFirst,
      isLast: isLast,
      hasIcon: hasIcon,
      labelTextPainter: labelTextPainter,
      icon: icon,
    );
  }
}

class _LeftTimelinePainter extends _TimelinePainter {
  _LeftTimelinePainter(
    super.onChanged, {
    required super.iconSize,
    required super.lineColor,
    required super.lineWidth,
    required super.timelinewidth,
    required super.isFirst,
    required super.isLast,
    required super.hasIcon,
    required super.labelTextPainter,
    required super.icon,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    // double iconBackgroundRadius = iconSize / 2;
    // if (hasIcon) {
    //   iconBackgroundRadius += iconSize / 2;
    // }
    // double iconMargin = iconBackgroundRadius / 2;
    // Size size = configuration.size!;
    // final Offset leftOffset = Offset(offset.dx + iconMargin, offset.dy);
    // final Offset centerOffset = size.centerLeft(leftOffset);
    // final Offset centerRight = size.centerRight(leftOffset);
    // final Offset centerTop = size.topLeft(leftOffset);
    // final Offset centerBottom = size.bottomLeft(leftOffset);

    // if (!isFirst) {
    //   canvas.drawLine(centerOffset, centerTop, linePaint);
    // }

    // if (!isLast) {
    //   canvas.drawLine(centerOffset, centerBottom, linePaint);
    // }

    // canvas.drawLine(centerOffset, centerRight, linePaint);
    // canvas.drawCircle(centerOffset, iconBackgroundRadius, circlePaint);

    double iconBackgroundRadius = iconSize / 2;
    if (hasIcon) {
      iconBackgroundRadius += iconSize / 2;
    }
    final Size size = configuration.size!;
    final Rect rect = offset & configuration.size!;

    final Offset leftOffset = Offset(offset.dx, offset.dy);
    final Offset centerOffset = size.centerLeft(leftOffset);
    final Offset centerRight = size.centerRight(leftOffset);

    canvas.drawCircle(centerOffset, iconBackgroundRadius, circlePaint);

    if (labelTextPainter != null) {
      labelTextPainter!.layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );

      labelTextPainter!.paint(
        canvas,
        Offset(centerOffset.dx + (iconBackgroundRadius + 6.0), 0.0),
      );
    }

    // final xCenter = (size.width - textPainter.width) / 2;
    // final yCenter = (size.height - textPainter.height) / 2;
    // final offset = Offset(xCenter, yCenter);
    // textPainter.paint(canvas, offset);
  }
}
