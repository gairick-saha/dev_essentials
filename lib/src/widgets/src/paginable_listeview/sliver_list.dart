part of '../../widgets.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

const Key keyForEmptyContainerWidgetOfPaginableListView =
    Key('EMPTY_CONTAINER_OF_PAGINABLELISTVIEW');

const Key keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate =
    Key('EMPTY_CONTAINER_OF_PAGINABLESLIVERCHILDBUILDERDELEGATE');

class PaginableSliverList extends StatelessWidget {
  const PaginableSliverList({
    Key? key,
    required this.itemBuilder,
    required this.errorIndicatorWidget,
    required this.progressIndicatorWidget,
    this.emptyWidget,
    this.findChildIndexCallback,
    this.childCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
  })  : separatorBuilder = null,
        super(key: key);

  const PaginableSliverList.separated({
    Key? key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.errorIndicatorWidget,
    required this.progressIndicatorWidget,
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
  final IndexedWidgetBuilder? separatorBuilder;
  final Widget Function(Exception exception, Future<void> Function() tryAgain)?
      errorIndicatorWidget;
  final Widget progressIndicatorWidget;
  final Widget? emptyWidget;
  final int? Function(Key)? findChildIndexCallback;
  final int? childCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? Function(Widget, int) semanticIndexCallback;
  final int semanticIndexOffset;

  @override
  Widget build(BuildContext context) {
    PaginationHookState? paginationHookState =
        ScrollableScaffoldWrapper.of(context);
    assert(paginationHookState != null,
        """You are trying to use PaginableSliverList without a ScrollableScaffoldWrapper.""");

    if (separatorBuilder != null) {
      final int computeActualChildCount =
          math.max(0, (childCount == null ? 0 : childCount!) * 2);
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == computeActualChildCount - 1) {
              if (paginationHookState!.listLastItem ==
                  PaginableListLastItem.emptyContainer) {
                return Container(
                  key:
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate,
                  child: emptyWidget ??
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 16.0,
                            bottom: MediaQuery.of(context).viewPadding.bottom +
                                16.0,
                          ),
                          child: Text(
                            'No more items',
                            textScaleFactor: Dev.textScaleFactor,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                );
              } else if (paginationHookState.listLastItem ==
                  PaginableListLastItem.errorIndicator) {
                return errorIndicatorWidget?.call(
                  paginationHookState.exceptionValue,
                  paginationHookState.performPagination,
                );
              }
              return progressIndicatorWidget;
            }

            final int itemIndex = index ~/ 2;
            final Widget widget;

            if (index.isEven) {
              widget = itemBuilder(context, itemIndex);
            } else {
              widget = separatorBuilder!.call(context, itemIndex);
            }
            return widget;
          },
          findChildIndexCallback: findChildIndexCallback,
          childCount: computeActualChildCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: (Widget _, int index) =>
              index.isEven ? index ~/ 2 : null,
          semanticIndexOffset: semanticIndexOffset,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == childCount) {
            if (paginationHookState!.listLastItem ==
                PaginableListLastItem.emptyContainer) {
              return Container(
                key:
                    keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate,
                child: emptyWidget ??
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom:
                              MediaQuery.of(context).viewPadding.bottom + 16.0,
                        ),
                        child: Text(
                          'No more items',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
              );
            } else if (paginationHookState.listLastItem ==
                PaginableListLastItem.errorIndicator) {
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
