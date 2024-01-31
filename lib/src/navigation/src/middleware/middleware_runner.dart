part of '../../navigation.dart';

class _MiddlewareRunner {
  _MiddlewareRunner(this._middlewares);

  final List<DevEssentialMiddleware>? _middlewares;

  List<DevEssentialMiddleware> _getMiddlewares() {
    final newMiddleware = _middlewares ?? <DevEssentialMiddleware>[];
    return List.of(newMiddleware)
      ..sort(
        (a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0),
      );
  }

  DevEssentialPage? runOnPageCalled(DevEssentialPage? page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageCalled(page);
    });
    return page;
  }

  RouteSettings? runRedirect(String? route) {
    RouteSettings? to;
    for (final element in _getMiddlewares()) {
      to = element.redirect(route);
      if (to != null) {
        break;
      }
    }
    Dev.print('Redirect to $to');
    return to;
  }

  DevEssentialPageBuilder? runOnPageBuildStart(DevEssentialPageBuilder? page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageBuildStart(page);
    });
    return page;
  }

  Widget runOnPageBuilt(Widget page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageBuilt(page);
    });
    return page;
  }

  void runOnPageDispose() =>
      _getMiddlewares().forEach((element) => element.onPageDispose());
}
