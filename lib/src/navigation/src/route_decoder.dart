part of '../navigation.dart';

class _RouteDecoder {
  _RouteDecoder({
    required this.name,
    required this.logText,
    required this.isDevEssentialRoute,
    required this.isBottomSheet,
    required this.isDialog,
    required this.arguments,
    required this.route,
  });

  final bool isDevEssentialRoute;
  final bool isBottomSheet;
  final bool isDialog;
  final String? name;
  final String? logText;
  final Object? arguments;
  final Route<dynamic>? route;

  static String? _extractRouteName(Route? route) {
    if (route?.settings.name != null) {
      return route!.settings.name;
    }

    if (route is DevEssentialRoute) {
      return route.routeName;
    }

    if (route is DevEssentialDialogRoute) {
      return 'DIALOG ${route.hashCode}';
    }

    if (route is DevEssentialModalBottomSheetRoute) {
      return 'BOTTOMSHEET ${route.hashCode}';
    }

    return null;
  }

  factory _RouteDecoder.ofRoute(Route<dynamic>? route) {
    return _RouteDecoder(
      name: route?.settings.name,
      logText: _extractRouteName(route),
      isDevEssentialRoute: route is DevEssentialRoute,
      isDialog: route is DevEssentialDialogRoute,
      isBottomSheet: route is DevEssentialModalBottomSheetRoute,
      arguments: route?.settings.arguments,
      route: route,
    );
  }
}
