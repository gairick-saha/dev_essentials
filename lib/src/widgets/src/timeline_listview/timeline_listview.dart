part of '../../widgets.dart';

typedef TimelineListItemBuilder = TimelineListItem Function(
  BuildContext context,
  int index,
);

class TimelineListView extends StatelessWidget {
  TimelineListView({
    Key? key,
    required List<TimelineListItem> children,
    this.padding,
    this.shrinkWrap = false,
    this.primary = false,
    this.reverse = false,
    this.controller,
    this.physics,
    this.lineColor,
    this.loadingColor,
    this.lineWidth = 2.5,
    this.iconSize = 24.0,
    this.labelStyle,
    this.timelineWidth,
  })  : isSliverItem = false,
        useBuilder = false,
        itemCount = children.length,
        itemBuilder = ((BuildContext context, int i) => children[i]),
        super(key: key);

  const TimelineListView.builder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.shrinkWrap = false,
    this.primary = false,
    this.reverse = false,
    this.controller,
    this.physics,
    this.iconSize = 24.0,
    this.lineColor,
    this.loadingColor,
    this.lineWidth = 2.5,
    this.labelStyle,
    this.timelineWidth,
  })  : isSliverItem = false,
        useBuilder = true,
        super(key: key);

  const TimelineListView.sliver({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.iconSize = 24.0,
    this.lineColor,
    this.loadingColor,
    this.lineWidth = 2.5,
    this.labelStyle,
    this.timelineWidth,
  })  : isSliverItem = true,
        shrinkWrap = null,
        primary = null,
        reverse = false,
        useBuilder = null,
        controller = null,
        physics = null,
        super(key: key);

  final bool isSliverItem;
  final EdgeInsetsGeometry? padding;
  final int itemCount;
  final bool? shrinkWrap;
  final bool? primary;
  final bool reverse;
  final bool? useBuilder;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final Color? lineColor;
  final Color? loadingColor;
  final double lineWidth;
  final double iconSize;
  final TimelineListItemBuilder itemBuilder;
  final TextStyle? labelStyle;
  final double? timelineWidth;

  @override
  Widget build(BuildContext context) {
    if (isSliverItem) {
      return SliverPadding(
        padding: padding ?? EdgeInsets.zero,
        sliver: SliverList.builder(
          itemCount: itemCount,
          itemBuilder: _buildTimelineItem,
        ),
      );
    } else {
      return ListView.builder(
        physics: physics,
        shrinkWrap: shrinkWrap ?? true,
        controller: controller,
        padding: padding ?? EdgeInsets.zero,
        reverse: reverse,
        primary: primary,
        itemCount: itemCount,
        itemBuilder: _buildTimelineItem,
      );
    }
  }

  Widget _buildTimelineItem(BuildContext context, int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final TimelineListItem model = itemBuilder(context, index);
        final bool isFirst = reverse ? index == (itemCount - 1) : index == 0;
        final bool isLast = reverse ? index == 0 : index == (itemCount - 1);
        final double timelinewidth =
            (timelineWidth ?? iconSize) + (iconSize * 2);

        final TextStyle? lableTextStyle =
            labelStyle ?? Dev.theme.textTheme.labelMedium;

        final TextSpan textSpan = TextSpan(
          text: model.label,
          style: labelStyle,
        );

        final TextPainter textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );

        return SizedBox(
          height: model.height,
          width: model.width,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: timelinewidth,
                child: AnimatedContainer(
                  duration: kThemeAnimationDuration,
                  decoration: _TimelineDecoration(
                    iconSize: iconSize,
                    isFirst: isFirst,
                    isLast: isLast,
                    lineColor: lineColor ?? Dev.theme.colorScheme.primary,
                    lineWidth: lineWidth,
                    timelinewidth: timelinewidth,
                    hasIcon: model.icon != null,
                    labelTextPainter: textPainter,
                    icon: Icon(
                      model.icon as IconData,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  width: timelinewidth,
                  alignment: Alignment.centerLeft,
                  // child: model.imageUrl != null
                  //     ? SizedBox.square(
                  //         dimension: iconSize,
                  //         child: Image.network(
                  //           model.imageUrl!,
                  //           filterQuality: FilterQuality.high,
                  //           loadingBuilder: (context, child, loadingProgress) =>
                  //               loadingProgress == null
                  //                   ? child
                  //                   : LoadingIndictor(
                  //                       color: Dev.theme.colorScheme.secondary,
                  //                       materialLoadingValue: (loadingProgress
                  //                                   .expectedTotalBytes ??
                  //                               0) /
                  //                           loadingProgress
                  //                               .cumulativeBytesLoaded,
                  //                     ),
                  //         ),
                  //       )
                  //     : model.icon != null
                  //         ? Icon(
                  //             model.icon as IconData,
                  //             color: Colors.white,
                  //             size: iconSize,
                  //           )
                  //         : const SizedBox.shrink(),
                ),
              ),
              Positioned.fill(
                left: timelinewidth,
                child: model.child(context, isFirst, isLast),
              ),
            ],
          ),
        );
      },
    );
  }
}
