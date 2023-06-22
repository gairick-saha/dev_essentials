part of '../navigation.dart';

class DevEssentialRouting {
  DevEssentialRouting({
    this.currentRoute,
    this.previousRoute,
    this.arguments,
    this.route,
    this.isBack,
    this.isBottomSheet,
    this.isDialog,
  });

  String? currentRoute;
  String? previousRoute;
  Object? arguments;
  Route<dynamic>? route;
  bool? isBack;
  bool? isBottomSheet;
  bool? isDialog;

  void update(void Function(DevEssentialRouting value) fn) {
    fn(this);
  }
}
