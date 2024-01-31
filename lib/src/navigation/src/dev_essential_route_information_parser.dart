part of '../navigation.dart';

class DevEssentialRouteInformationParser
    extends RouteInformationParser<DevEssentialRouteDecoder> {
  factory DevEssentialRouteInformationParser.createInformationParser(
          {String initialRoute = '/'}) =>
      DevEssentialRouteInformationParser(initialRoute: initialRoute);

  final String initialRoute;

  DevEssentialRouteInformationParser({
    required this.initialRoute,
  }) {
    Dev.log('DevEssentialRouteInformationParser is created !');
  }

  @override
  SynchronousFuture<DevEssentialRouteDecoder> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    final uri = routeInformation.uri;
    var location = uri.toString();
    if (location == '/') {
      if (!(DevEssentialHookState.instance.rootDelegate)
          .registeredRoutes
          .any((element) => element.name == '/')) {
        location = initialRoute;
      }
    } else if (location.isEmpty) {
      location = initialRoute;
    }

    Dev.log('DevEssentialRouteInformationParser: route location: $location');

    return SynchronousFuture(DevEssentialRouteDecoder.fromRoute(location));
  }

  @override
  RouteInformation? restoreRouteInformation(
          DevEssentialRouteDecoder configuration) =>
      RouteInformation(
        uri: Uri.tryParse(configuration.pageSettings?.name ?? ''),
        state: null,
      );
}
