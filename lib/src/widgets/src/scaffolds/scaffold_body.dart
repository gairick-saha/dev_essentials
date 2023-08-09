part of '../../widgets.dart';

class _BuildInheritedScrollableBody extends InheritedWidget {
  const _BuildInheritedScrollableBody({
    required Widget child,
    required this.paginationHookState,
  }) : super(child: child);

  final PaginationHookState paginationHookState;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class _BuildBody extends HookWidget {
  const _BuildBody({
    Key? key,
    required this.childrens,
    required this.onRefresh,
    required this.scrollController,
    required this.shrinkWrap,
    required this.hasAppbar,
    required this.physics,
    required this.reverse,
    required this.allowPagination,
    required this.onPaginate,
  }) : super(key: key);

  final List<Widget> childrens;
  final Future<void> Function()? onRefresh;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool hasAppbar;
  final bool reverse;
  final bool allowPagination;
  final OnPaginateCallback? onPaginate;

  @override
  Widget build(BuildContext context) {
    PaginationHookState paginationHookState =
        usePaginationHook(loadMore: onPaginate);

    late Widget childWidget;

    if (onRefresh == null) {
      childWidget = _buildCustomScrollView(
        context,
        paginationHookState: paginationHookState,
      );
    } else {
      childWidget = _buildRefreshableScrollView(
        context,
        paginationHookState: paginationHookState,
      );
    }

    return _BuildInheritedScrollableBody(
      paginationHookState: paginationHookState,
      child: childWidget,
    );
  }

  Widget _buildRefreshableScrollView(
    BuildContext context, {
    required PaginationHookState paginationHookState,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh!,
      edgeOffset: hasAppbar
          ? MediaQuery.of(context).viewPadding.top + (kToolbarHeight + 10)
          : 0,
      color: Theme.of(context).indicatorColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      displacement: 0,
      child: _buildCustomScrollView(
        context,
        paginationHookState: paginationHookState,
      ),
    );
  }

  Widget _buildCustomScrollView(
    BuildContext context, {
    required PaginationHookState paginationHookState,
  }) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (ScrollUpdateNotification scrollUpdateNotification) {
        if (allowPagination) {
          if (paginationHookState
                  .isAlmostAtTheEndOfTheScroll(scrollUpdateNotification) &&
              paginationHookState
                  .isScrollingDownwards(scrollUpdateNotification)) {
            if (!paginationHookState.isLoadMoreBeingCalled) {
              paginationHookState.performPagination();
            }
          }
        }
        return true;
      },
      child: CustomScrollView(
        key: key,
        scrollBehavior: const DevEssentialCustomScrollBehavior(),
        controller: scrollController,
        physics: physics,
        slivers: childrens,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
      ),
    );
  }
}
