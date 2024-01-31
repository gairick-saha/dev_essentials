part of '../../navigation.dart';

abstract class _RouteMiddleware {
  int? priority;

  RouteSettings? redirect(String route);

  FutureOr<DevEssentialRouteDecoder?> redirectDelegate(
      DevEssentialRouteDecoder route);

  DevEssentialPage? onPageCalled(DevEssentialPage page);

  DevEssentialPageBuilder? onPageBuildStart(DevEssentialPageBuilder page);

  Widget onPageBuilt(Widget page);

  void onPageDispose();
}
