part of '../../widgets.dart';

class _BuildBody extends StatelessWidget {
  const _BuildBody({
    Key? key,
    required this.childrens,
    required this.onRefresh,
    required this.scrollController,
    required this.shrinkWrap,
    required this.hasAppbar,
    required this.physics,
    required this.reverse,
  }) : super(key: key);

  final List<Widget> childrens;
  final Future<void> Function()? onRefresh;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool hasAppbar;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return onRefresh == null
        ? CustomScrollView(
            scrollBehavior: const DevEssentialCustomScrollBehavior(),
            key: key,
            controller: scrollController,
            physics: physics,
            slivers: childrens,
            shrinkWrap: shrinkWrap,
            reverse: reverse,
          )
        : RefreshIndicator(
            onRefresh: onRefresh!,
            edgeOffset: hasAppbar
                ? MediaQuery.of(context).viewPadding.top + (kToolbarHeight + 10)
                : 0,
            color: Theme.of(context).indicatorColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            displacement: 0,
            child: CustomScrollView(
              scrollBehavior: const DevEssentialCustomScrollBehavior(),
              key: key,
              controller: scrollController,
              physics: physics ??
                  const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
              slivers: childrens,
              shrinkWrap: shrinkWrap,
              reverse: reverse,
            ),
          );
  }
}
