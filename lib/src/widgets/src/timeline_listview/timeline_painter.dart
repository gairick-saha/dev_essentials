part of '../../widgets.dart';

abstract class _TimelinePainter extends BoxPainter {
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
    required this.hasLegend,
    required this.spaceBetweenLegendAndTimeLine,
    iconBackground,
  })  : linePaint = Paint()
          ..color = lineColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke,
        circlePaint = Paint()
          ..color = iconBackground ?? Dev.theme.colorScheme.primary
          ..style = PaintingStyle.fill;

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
  final bool hasLegend;
  final double spaceBetweenLegendAndTimeLine;
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
    required this.hasLegend,
    required this.spaceBetweenLegendAndTimeLine,
  });

  final double iconSize;
  final bool isFirst;
  final bool isLast;
  final Color lineColor;
  final double lineWidth;
  final double timelinewidth;
  final bool hasIcon;
  final TextPainter? labelTextPainter;
  final bool hasLegend;
  final double spaceBetweenLegendAndTimeLine;

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
      hasLegend: hasLegend,
      spaceBetweenLegendAndTimeLine: spaceBetweenLegendAndTimeLine,
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
    required super.hasLegend,
    required super.spaceBetweenLegendAndTimeLine,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    double iconBackgroundRadius = (iconSize / 2);
    double iconMargin = iconBackgroundRadius;

    if (!hasIcon) {
      iconBackgroundRadius = iconBackgroundRadius / 2;
      iconMargin = iconBackgroundRadius;
    } else {
      iconBackgroundRadius += 2.0;
    }

    final Size size = configuration.size!;
    final Offset leftOffset = Offset(offset.dx + iconMargin, offset.dy);
    final Offset centerLeftOffset = size.centerLeft(leftOffset);
    final Offset centerRightOffset = size.centerRight(leftOffset);
    final Offset centerTopOffset =
        size.centerLeft(Offset(leftOffset.dx, leftOffset.dy - iconMargin));
    final Offset centerBottomOffset =
        size.centerLeft(Offset(leftOffset.dx, leftOffset.dy + iconMargin));
    final Offset leftTopOffset = size.topLeft(leftOffset);
    final Offset leftBottomOffset =
        size.bottomLeft(Offset(leftOffset.dx, leftOffset.dy * 2));

    if (isFirst && hasLegend) {
      canvas.drawLine(
          Offset(leftTopOffset.dx,
              leftTopOffset.dy - spaceBetweenLegendAndTimeLine),
          centerTopOffset,
          linePaint);
    }

    if (!isFirst) {
      canvas.drawLine(leftTopOffset, centerTopOffset, linePaint);
    }

    if (!isLast) {
      canvas.drawLine(centerBottomOffset, leftBottomOffset, linePaint);
    }

    canvas.drawLine(centerLeftOffset, centerRightOffset, linePaint);
    canvas.drawCircle(centerLeftOffset, iconBackgroundRadius, circlePaint);

    if (labelTextPainter != null) {
      final Offset textOffset = Offset(
          centerTopOffset.dx + (iconMargin * 2), centerTopOffset.dy / 2.0);
      labelTextPainter!.paint(canvas, textOffset);
    }
  }
}
