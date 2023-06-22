part of '../extensions.dart';

extension BottomSheetExtension on DevEssential {
  Future<T?> showBottomSheet<T>(
    Widget bottomsheet, {
    Color? backgroundColor,
    double? elevation,
    bool persistent = true,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool? ignoreSafeArea,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? settings,
    Duration? enterBottomSheetDuration,
    Duration? exitBottomSheetDuration,
  }) {
    return Navigator.of(overlayContext!, rootNavigator: useRootNavigator)
        .push(DevEssentialModalBottomSheetRoute<T>(
      builder: (_) => bottomsheet,
      isPersistent: persistent,
      theme: Theme.of(context),
      isScrollControlled: isScrollControlled,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      shape: shape,
      removeTop: ignoreSafeArea ?? true,
      clipBehavior: clipBehavior,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      settings: settings,
      enableDrag: enableDrag,
      enterBottomSheetDuration: enterBottomSheetDuration ?? 250.milliseconds,
      exitBottomSheetDuration: exitBottomSheetDuration ?? 200.milliseconds,
    ));
  }
}
