part of '../navigation.dart';

class _DevEssentialRoutingData {
  final bool isDevEssentialPageRoute;
  final bool isBottomSheet;
  final bool isDialog;
  final String? name;

  _DevEssentialRoutingData({
    required this.name,
    required this.isDevEssentialPageRoute,
    required this.isBottomSheet,
    required this.isDialog,
  });

  factory _DevEssentialRoutingData.ofRoute(Route? route) {
    return _DevEssentialRoutingData(
      name: _extractRouteName(route),
      isDevEssentialPageRoute: route is DevEssentialPageRoute ||
          route is DevEssentialPage ||
          route is PageRoute,
      isDialog: route is DevEssentialDialogRoute,
      isBottomSheet: route is DevEssentialModalBottomSheetRoute,
    );
  }
}

class DevEssentialRouting {
  DevEssentialRouting({
    this.current,
    this.previous,
    this.arguments,
    this.route,
    this.isBack,
    this.isBottomSheet = false,
    this.isDialog = false,
  });

  String? current;
  String? previous;
  Object? arguments;
  Route<dynamic>? route;
  bool? isBack;
  bool isBottomSheet;
  bool isDialog;

  void update(void Function(DevEssentialRouting value) fn) {
    fn(this);
  }
}
