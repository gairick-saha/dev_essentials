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

  final SliverGridDelegate gridDelegate;

  @override
  Widget build(BuildContext context) {
    PaginationHookState? paginationHookState =
        ScrollableScaffoldWrapper.of(context);
    assert(paginationHookState != null,
        """You are trying to use PaginableSliverGridList without a ScrollableScaffoldWrapper.""");

    // return SliverStaggeredGrid.countBuilder(
    //   staggeredTileBuilder: (int index) {
    //     // Customize staggered tile configuration based on your requirements.
    //     return const StaggeredTile.fit(2);
    //   },
    //
    //   mainAxisSpacing: 16.0,
    //   crossAxisSpacing: 16.0,
    //   crossAxisCount: 1,
    //   itemBuilder: (BuildContext context, int index) {
    //     if (index == childCount) {
    //       if (paginationHookState!.listLastItem ==
    //           PaginableListLastItem.emptyContainer) {
    //         return Container(
    //           key:
    //               keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate,
    //           child: emptyWidget ??
    //               Center(
    //                 child: Padding(
    //                   padding: EdgeInsets.only(
    //                     top: 16.0,
    //                     bottom:
    //                         MediaQuery.of(context).viewPadding.bottom + 16.0,
    //                   ),
    //                   child: Text(
    //                     'No more items',
    //                     style: Theme.of(context).textTheme.bodyLarge,
    //                   ),
    //                 ),
    //               ),
    //         );
    //       } else if (paginationHookState.listLastItem ==
    //           PaginableListLastItem.errorIndicator) {
    //         return errorIndicatorWidget!.call(
    //           paginationHookState.exceptionValue,
    //           paginationHookState.performPagination,
    //         );
    //       }
    //       return progressIndicatorWidget;
    //     }
    //     return itemBuilder(context, index);
    //   },
    //   itemCount: 2,
    // );

    return  SliverGrid(
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
// class PaginableSliverGridList extends StatelessWidget {
//   const PaginableSliverGridList({
//     Key? key,
//     required this.itemBuilder,
//     required this.errorIndicatorWidget,
//     required this.progressIndicatorWidget,
//     this.emptyWidget,
//     this.findChildIndexCallback,
//     this.childCount,
//     this.addAutomaticKeepAlives = true,
//     this.addRepaintBoundaries = true,
//     this.addSemanticIndexes = true,
//     this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
//     this.semanticIndexOffset = 0,
//   }) : super(key: key);
//
//   final IndexedWidgetBuilder itemBuilder;
//   final Widget Function(Exception exception, Future<void> Function() tryAgain) errorIndicatorWidget;
//   final Widget progressIndicatorWidget;
//   final Widget? emptyWidget;
//   final int? Function(Key)? findChildIndexCallback;
//   final int? childCount;
//   final bool addAutomaticKeepAlives;
//   final bool addRepaintBoundaries;
//   final bool addSemanticIndexes;
//   final int? Function(Widget, int) semanticIndexCallback;
//   final int semanticIndexOffset;
//
//   @override
//   Widget build(BuildContext context) {
//     PaginationHookState? paginationHookState = ScrollableScaffoldWrapper.of(context);
//     assert(paginationHookState != null, """You are trying to use PaginableSliverGridList without a ScrollableScaffoldWrapper.""");
//
//     return SliverFillRemaining(
//       child: StaggeredGridView.countBuilder( shrinkWrap: true,
//         crossAxisCount: 2, // Adjust the number of columns as needed
//         staggeredTileBuilder: (int index) {
//           return StaggeredTile.fit(1); // Adjust the tile size as needed
//         },
//         mainAxisSpacing: 4.0,
//         crossAxisSpacing: 4.0,
//         itemCount: childCount == null ? 0 : childCount!,
//         itemBuilder: (BuildContext context, int index) {
//           if (index == childCount) {
//             if (paginationHookState!.listLastItem == PaginableListLastItem.emptyContainer) {
//               return Container(
//                 key: keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate,
//                 child: emptyWidget ??
//                     Center(
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                           top: 16.0,
//                           bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
//                         ),
//                         child: Text(
//                           'No more items',
//                           style: Theme.of(context).textTheme.bodyLarge,
//                         ),
//                       ),
//                     ),
//               );
//             } else if (paginationHookState.listLastItem == PaginableListLastItem.errorIndicator) {
//               return errorIndicatorWidget.call(
//                 paginationHookState.exceptionValue,
//                 paginationHookState.performPagination,
//               );
//             }
//             return progressIndicatorWidget;
//           }
//           return itemBuilder(context, index);
//         },
//       ),
//     );
//   }
// }
