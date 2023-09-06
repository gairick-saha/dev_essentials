part of '../../widgets.dart';

class PaginableSliverGridList extends StatelessWidget {
  const PaginableSliverGridList({
    Key? key,
    required this.itemBuilder,
    required this.errorIndicatorWidget,
    required this.progressIndicatorWidget,
    required this.gridDelegate,
    this.emptyWidget,
    this.findChildIndexCallback,
    this.childCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
  }) : super(key: key);

  final IndexedWidgetBuilder itemBuilder;
  final Widget Function(Exception exception, Future<void> Function() tryAgain)? errorIndicatorWidget;
  final Widget progressIndicatorWidget;
  final Widget? emptyWidget;
  final int? Function(Key)? findChildIndexCallback;
  final int? childCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? Function(Widget, int) semanticIndexCallback;
  final int semanticIndexOffset;

  final SliverGridDelegate gridDelegate;

  @override
  Widget build(BuildContext context) {
    PaginationHookState? paginationHookState = ScrollableScaffoldWrapper.of(context);
    assert(paginationHookState != null, """You are trying to use PaginableSliverGridList without a ScrollableScaffoldWrapper.""");

    return SliverGrid(
      gridDelegate: gridDelegate,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == childCount) {
            if (paginationHookState!.listLastItem == PaginableListLastItem.emptyContainer) {
              return Container(
                key: keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate,
                child: emptyWidget ??
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
                        ),
                        child: Text(
                          'No more items',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
              );
            } else if (paginationHookState.listLastItem == PaginableListLastItem.errorIndicator) {
              return errorIndicatorWidget?.call(
                paginationHookState.exceptionValue,
                paginationHookState.performPagination,
              );
            }
            return progressIndicatorWidget;
          }
          return itemBuilder(context, index);
        },
        findChildIndexCallback: findChildIndexCallback,
        childCount: childCount == null ? null : childCount! + 1,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        semanticIndexCallback: semanticIndexCallback,
        semanticIndexOffset: semanticIndexOffset,
      ),
    );
  }
}
