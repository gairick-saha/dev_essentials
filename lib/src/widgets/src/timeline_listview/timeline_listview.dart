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
    this.legendText,
    this.legendColor,
    this.legendTextStyle,
    this.spaceBetweenLegendAndTimeLine = 16.0,
    this.legendTextPadding = const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 5.0,
    ),
  })  : isSliverItem = false,
        useBuilder = false,
        allowPagination = false,
        errorIndicatorWidget = null,
        progressIndicatorWidget = null,
        emptyWidget = null,
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
    this.legendText,
    this.legendColor,
    this.legendTextStyle,
    this.spaceBetweenLegendAndTimeLine = 16.0,
    this.legendTextPadding = const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 5.0,
    ),
  })  : isSliverItem = false,
        useBuilder = true,
        allowPagination = false,
        errorIndicatorWidget = null,
        emptyWidget = null,
        progressIndicatorWidget = null,
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
    this.legendText,
    this.legendColor,
    this.legendTextStyle,
    this.spaceBetweenLegendAndTimeLine = 16.0,
    this.legendTextPadding = const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 5.0,
    ),
    this.allowPagination = false,
    this.errorIndicatorWidget,
    this.progressIndicatorWidget,
    this.emptyWidget,
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
  final String? legendText;
  final Color? legendColor;
  final TextStyle? legendTextStyle;
  final double spaceBetweenLegendAndTimeLine;
  final EdgeInsetsGeometry legendTextPadding;
  final bool allowPagination;
  final Widget Function(Exception exception, Future<void> Function() tryAgain)?
      errorIndicatorWidget;
  final Widget? progressIndicatorWidget;
  final Widget? emptyWidget;
  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry timelinePadding = padding ?? EdgeInsets.zero;
    Widget? legend;
    TextPainter? legendTextPainter;
    TextSpan? legendTextSpan;

    if (legendText != null) {
      legendTextSpan = TextSpan(
        text: legendText,
        style: legendTextStyle ??
            Dev.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      );

      legendTextPainter = TextPainter(
        text: legendTextSpan,
        textDirection: TextDirection.ltr,
      );

      legendTextPainter.layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );

      timelinePadding = timelinePadding.add(
        EdgeInsets.only(
          left:
              (legendTextPainter.size.width / 3) + (legendTextPadding.vertical),
          top: spaceBetweenLegendAndTimeLine,
        ),
      );

      legend = Align(
        alignment: Alignment.topLeft,
        child: Material(
          animationDuration: kThemeAnimationDuration,
          color: legendColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: lineColor ?? Dev.theme.colorScheme.primary,
              width: lineWidth,
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0,
          child: Padding(
            padding: legendTextPadding,
            child: Text.rich(
              legendTextSpan,
              textScaleFactor: Dev.textScaleFactor,
              style: legendTextSpan.style,
            ),
          ),
        ),
      );
    }

    if (isSliverItem) {
      return MultiSliver(
        children: [
          if (legend != null)
            SliverToBoxAdapter(
              child: legend,
            ),
          SliverPadding(
            padding: timelinePadding,
            sliver: allowPagination
                ? PaginableSliverList(
                    childCount: itemCount,
                    itemBuilder: _buildTimelineItem,
                    errorIndicatorWidget: errorIndicatorWidget,
                    progressIndicatorWidget: progressIndicatorWidget ??
                        const Center(
                          child: LoadingIndictor(),
                        ),
                    emptyWidget: emptyWidget,
                  )
                : SliverList.builder(
                    itemBuilder: _buildTimelineItem,
                    itemCount: itemCount,
                  ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (legend != null) legend,
          Flexible(
            child: ListView.builder(
              physics: physics,
              shrinkWrap: shrinkWrap ?? true,
              controller: controller,
              padding: timelinePadding,
              reverse: reverse,
              primary: primary,
              itemCount: itemCount,
              itemBuilder: _buildTimelineItem,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildTimelineItem(BuildContext context, int index) {
    return MediaQuery.removeViewPadding(
      context: context,
      removeBottom: true,
      removeTop: true,
      removeLeft: true,
      removeRight: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final TimelineListItem model = itemBuilder(context, index);
          final bool isFirst = reverse ? index == (itemCount - 1) : index == 0;
          final bool isLast = reverse ? index == 0 : index == (itemCount - 1);
          double timelineContainerwidth = timelineWidth ?? iconSize;

          TextPainter? textPainter;

          if (model.icon != null || model.imageUrl != null) {
            timelineContainerwidth += iconSize / 2;
          }

          if (model.label != null) {
            final TextSpan textSpan = TextSpan(
              text: model.label,
              style: labelStyle ?? Dev.theme.textTheme.labelMedium,
            );

            textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );

            textPainter.layout(
              minWidth: 0,
              maxWidth: (timelineWidth ?? iconSize) + (iconSize * 2),
            );

            timelineContainerwidth -= iconSize / 2;
            timelineContainerwidth +=
                (timelineWidth ?? iconSize) + textPainter.size.width;

            if (model.icon == null && model.imageUrl == null) {
              timelineContainerwidth =
                  (timelineWidth ?? iconSize) + textPainter.size.width;
            }
          }

          return SizedBox(
            height: model.height,
            width: model.width,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                AnimatedPositioned(
                  duration: kThemeAnimationDuration,
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: timelineContainerwidth,
                  child: AnimatedContainer(
                    duration: kThemeAnimationDuration,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    decoration: _TimelineDecoration(
                      iconSize: iconSize,
                      isFirst: isFirst,
                      isLast: isLast,
                      lineColor: lineColor ?? Dev.theme.colorScheme.primary,
                      lineWidth: lineWidth,
                      timelinewidth: timelineContainerwidth,
                      hasIcon: model.icon != null || model.imageUrl != null,
                      labelTextPainter: textPainter,
                      hasLegend: legendText != null,
                      spaceBetweenLegendAndTimeLine:
                          spaceBetweenLegendAndTimeLine,
                    ),
                    width: timelineContainerwidth,
                    alignment: Alignment.centerLeft,
                    child: model.imageUrl != null
                        ? SizedBox.square(
                            dimension: iconSize,
                            child: Image.network(
                              model.imageUrl!,
                              filterQuality: FilterQuality.high,
                              loadingBuilder: (context, child,
                                      loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : LoadingIndictor(
                                          color:
                                              Dev.theme.colorScheme.secondary,
                                          materialLoadingValue: (loadingProgress
                                                      .expectedTotalBytes ??
                                                  0) /
                                              loadingProgress
                                                  .cumulativeBytesLoaded,
                                        ),
                            ),
                          )
                        : model.icon != null
                            ? Icon(
                                model.icon as IconData,
                                color: Colors.white,
                                size: iconSize,
                              )
                            : const SizedBox.shrink(),
                  ),
                ),
                AnimatedPositioned(
                  duration: kThemeAnimationDuration,
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: timelineContainerwidth,
                  child: model.child(context, isFirst, isLast),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
