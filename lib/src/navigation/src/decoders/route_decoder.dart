part of '../../navigation.dart';

class DevEssentialRouteDecoder {
  const DevEssentialRouteDecoder(
    this.currentTreeBranch,
    this.pageSettings,
  );

  final List<DevEssentialPage> currentTreeBranch;
  final DevEssentialPageSettings? pageSettings;

  factory DevEssentialRouteDecoder.fromRoute(String location) {
    var uri = Uri.parse(location);
    final args = DevEssentialPageSettings(uri);
    final decoder = DevEssentialHookState.instance.rootDelegate
        .matchRoute(location, arguments: args);
    decoder.route = decoder.route?.copyWith(
      completer: null,
      arguments: args,
      parameters: args.params,
    );
    return decoder;
  }

  DevEssentialPage? get route =>
      currentTreeBranch.isEmpty ? null : currentTreeBranch.last;

  DevEssentialPage routeOrUnknown(DevEssentialPage onUnknow) =>
      currentTreeBranch.isEmpty ? onUnknow : currentTreeBranch.last;

  set route(DevEssentialPage? getPage) {
    if (getPage == null) return;
    if (currentTreeBranch.isEmpty) {
      currentTreeBranch.add(getPage);
    } else {
      currentTreeBranch[currentTreeBranch.length - 1] = getPage;
    }
  }

  List<DevEssentialPage>? get currentChildren => route?.children;

  Map<String, String> get parameters => pageSettings?.params ?? {};

  dynamic get args {
    return pageSettings?.arguments;
  }

  T? arguments<T>() {
    final args = pageSettings?.arguments;
    if (args is T) {
      return pageSettings?.arguments as T;
    } else {
      return null;
    }
  }

  void replaceArguments(Object? arguments) {
    final newRoute = route;
    if (newRoute != null) {
      final index = currentTreeBranch.indexOf(newRoute);
      currentTreeBranch[index] = newRoute.copyWith(arguments: arguments);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DevEssentialRouteDecoder &&
        listEquals(other.currentTreeBranch, currentTreeBranch) &&
        other.pageSettings == pageSettings;
  }

  @override
  int get hashCode => currentTreeBranch.hashCode ^ pageSettings.hashCode;

  @override
  String toString() =>
      'DevEssentialRouteDecoder(currentTreeBranch: $currentTreeBranch, pageSettings: $pageSettings)';
}
