part of '../navigation.dart';

class DevEssentialRouteDecoder {
  const DevEssentialRouteDecoder(
    this.treeBranch,
    this.parameters,
    this.arguments,
  );

  final List<DevEssentialPage> treeBranch;

  DevEssentialPage? get route => treeBranch.isEmpty ? null : treeBranch.last;

  String? get name => route?.name;

  final Map<String, String> parameters;

  final Object? arguments;

  void replaceArguments(Object? arguments) {
    final DevEssentialPage? currentRoute = route;
    if (currentRoute != null) {
      final int index = treeBranch.indexOf(currentRoute);
      treeBranch[index] = currentRoute.copyWith(arguments: arguments);
    }
  }
}

class _ObserverData {
  _ObserverData({
    required this.name,
    required this.logText,
    required this.isDevEssentialRoute,
    required this.isBottomSheet,
    required this.isDialog,
    required this.arguments,
    required this.parameters,
    required this.route,
  });

  final bool isDevEssentialRoute;
  final bool isBottomSheet;
  final bool isDialog;
  final String? name;
  final String? logText;
  final Object? arguments;
  final Map<String, String>? parameters;
  final Route<dynamic>? route;

  static String? _extractRouteName(Route? route) {
    if (route is DevEssentialRoute) {
      return route.routeName;
    }

    if (route is DevEssentialDialogRoute) {
      return 'DIALOG ${route.settings.name ?? route.hashCode}';
    }

    if (route is DevEssentialModalBottomSheetRoute) {
      return 'BOTTOMSHEET ${route.settings.name ?? route.hashCode}';
    }

    if (route?.settings.name != null) {
      return route!.settings.name;
    }

    return null;
  }

  factory _ObserverData.fromRoute(
    Route<dynamic>? route,
  ) {
    return _ObserverData(
      name: route?.settings.name,
      logText: _extractRouteName(route),
      isDevEssentialRoute: route is DevEssentialRoute,
      isDialog: route is DevEssentialDialogRoute,
      isBottomSheet: route is DevEssentialModalBottomSheetRoute,
      arguments: route?.settings.arguments,
      parameters: route is DevEssentialRoute ? route.parameters : null,
      route: route,
    );
  }
}
