part of '../../widgets.dart';

class _DevEssentialPageViewControllerData {
  _DevEssentialPageViewControllerData({
    required this.index,
  });

  final int index;

  _DevEssentialPageViewControllerData copyWith({
    int? index,
  }) =>
      _DevEssentialPageViewControllerData(
        index: index ?? this.index,
      );
}

class DevEssentialPageViewController
    extends ValueNotifier<_DevEssentialPageViewControllerData> {
  DevEssentialPageViewController({int initialPage = 0})
      : super(_DevEssentialPageViewControllerData(index: initialPage));

  int get index => value.index;

  void changePage(int index) => value = value.copyWith(index: index);
}
