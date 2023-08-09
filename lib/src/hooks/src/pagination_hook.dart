// ignore_for_file: library_private_types_in_public_api

part of '../hooks.dart';

typedef OnPaginateCallback = Future<void> Function();

enum PaginableListLastItem { progressIndicator, errorIndicator, emptyContainer }

PaginationHookState usePaginationHook({
  required OnPaginateCallback? loadMore,
}) =>
    use(_PaginationHook(
      loadMore: loadMore,
    ));

class _PaginationHook extends Hook<PaginationHookState> {
  const _PaginationHook({
    required this.loadMore,
  });

  final OnPaginateCallback? loadMore;

  @override
  HookState<PaginationHookState, Hook<PaginationHookState>> createState() =>
      PaginationHookState();
}

class PaginationHookState
    extends HookState<PaginationHookState, _PaginationHook> {
  late PaginationHookState _paginationHookState;

  bool isLoadMoreBeingCalled = false;

  bool isAlmostAtTheEndOfTheScroll(
          ScrollUpdateNotification scrollUpdateNotification) =>
      scrollUpdateNotification.metrics.pixels >=
      scrollUpdateNotification.metrics.maxScrollExtent * 0.95;

  bool isScrollingDownwards(
          ScrollUpdateNotification scrollUpdateNotification) =>
      scrollUpdateNotification.scrollDelta! > 0.0;

  PaginableListLastItem listLastItem = PaginableListLastItem.emptyContainer;
  Exception exceptionValue = Exception();

  @override
  void initHook() {
    _paginationHookState = this;
    super.initHook();
  }

  @override
  void didUpdateHook(covariant _PaginationHook oldHook) {
    if (oldHook.loadMore != hook.loadMore) {
      updateState();
    }
  }

  Future<void> performPagination() async {
    listLastItem = PaginableListLastItem.progressIndicator;
    isLoadMoreBeingCalled = true;
    updateState();
    try {
      await hook.loadMore?.call();
      isLoadMoreBeingCalled = false;
      listLastItem = PaginableListLastItem.emptyContainer;
    } on Exception catch (exception) {
      exceptionValue = exception;
      listLastItem = PaginableListLastItem.errorIndicator;
    }
    updateState();
  }

  void updateState() => setState(() {});

  @override
  PaginationHookState build(BuildContext context) => _paginationHookState;
}
