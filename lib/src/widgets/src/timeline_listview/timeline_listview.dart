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
