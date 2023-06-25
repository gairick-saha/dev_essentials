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

  void replaceParameters(Object? arguments) {
    final DevEssentialPage? currentRoute = route;
    if (currentRoute != null) {
      final int index = treeBranch.indexOf(currentRoute);
      treeBranch[index] = currentRoute.copyWith(parameters: parameters);
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

  factory _ObserverData.fromRoute(Route<dynamic>? route) {
    return _ObserverData(
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
