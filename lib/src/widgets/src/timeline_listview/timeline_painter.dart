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
  });

  final double iconSize;
  final bool isFirst;
  final bool isLast;
  final Color lineColor;
  final double lineWidth;
  final double timelinewidth;
  final bool hasIcon;
  final TextPainter? labelTextPainter;

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



















// final Offset leftOffset = Offset(offset.dx + 5.0, offset.dy);
  // final Offset top = size.topLeft(Offset(leftOffset.dx, 0.0));
  // final Offset centerOffset = size.center(leftOffset);
  // final Offset centerTopOffset =
  //     size.centerLeft(Offset(leftOffset.dx, leftOffset.dy - 5.0));
  // final Offset bottomLeftOffset = size.bottomLeft(leftOffset);
  // final Offset leftTopOffset = size.topLeft(leftOffset);
  // final Offset centerOffset = size.center(leftOffset);
  // final Offset centerTopOffset =
  //     size.centerLeft(Offset(leftOffset.dx, leftOffset.dy - 5.0));
  // final Offset centerLeftOffset = size.centerLeft(leftOffset);
  // final Offset centerRightOffset = size.centerRight(leftOffset);
  // final Offset leftBottomOffset = size.bottomLeft(leftOffset);

  // Dev.print(centerOffset.dx / 2);

  // if (labelTextPainter != null) {
  //   labelTextPainter!.paint(
  //     canvas,
  //     Offset(
  //       centerOffset.dx / 2,
  //       (centerOffset.dy - (labelTextPainter!.size.height / 2) - 10),
  //     ),
  //   );
  // }

  // if (!isFirst) {
  //   canvas.drawLine(leftTopOffset, leftBottomOffset, linePaint);
  // }

  // canvas.drawLine(centerLeftOffset,
  //     Offset(centerRightOffset.dx, centerRightOffset.dy), linePaint);
  // canvas.drawCircle(centerLeftOffset, iconBackgroundRadius / 2, circlePaint);