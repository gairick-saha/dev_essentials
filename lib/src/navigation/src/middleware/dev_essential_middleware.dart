part of '../../navigation.dart';

class DevEssentialMiddleware implements _RouteMiddleware {
  @override
  int? priority = 0;

  DevEssentialMiddleware({this.priority});

  @override
  RouteSettings? redirect(String? route) => null;

  @override
  DevEssentialPage? onPageCalled(DevEssentialPage? page) => page;

  @override
  DevEssentialPageBuilder? onPageBuildStart(DevEssentialPageBuilder? page) =>
      page;

  @override
  Widget onPageBuilt(Widget page) => page;

  @override
  void onPageDispose() {}

  @override
  FutureOr<DevEssentialRouteDecoder?> redirectDelegate(
    DevEssentialRouteDecoder route,
  ) =>
      (route);
}
