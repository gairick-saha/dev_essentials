part of '../navigation.dart';

typedef DevEssentialNavigatorItemBuilderBuilder = Widget Function(
  BuildContext context,
  List<String> routes,
  int index,
);

class DevEssentialIndexedRouteBuilder<T> extends StatelessWidget {
  const DevEssentialIndexedRouteBuilder({
    Key? key,
    required this.builder,
    required this.routes,
  }) : super(key: key);

  final List<String> routes;
  final DevEssentialNavigatorItemBuilderBuilder builder;

  int _getCurrentIndex(String currentLocation) {
    for (int i = 0; i < routes.length; i++) {
      if (currentLocation.startsWith(routes[i])) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = context.location;
    final index = _getCurrentIndex(location);

    return builder(context, routes, index);
  }
}
