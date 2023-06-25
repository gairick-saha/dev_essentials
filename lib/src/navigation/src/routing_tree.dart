part of '../navigation.dart';

class DevEssentialRoutingTree {
  DevEssentialRoutingTree({
    required this.routes,
  });

  final List<DevEssentialPage> routes;

  void addRoutes(List<DevEssentialPage> pages) {
    for (DevEssentialPage page in pages) {
      _addPage(page);
    }
  }

  void _addPage(DevEssentialPage page) {
    routes.add(page);

    for (DevEssentialPage page in _flattenPage(page)) {
      _addPage(page);
    }
  }

  List<DevEssentialPage> _flattenPage(DevEssentialPage parentPage) {
    final List<DevEssentialPage> result = <DevEssentialPage>[];
    if (parentPage.childrens.isEmpty) {
      return result;
    }

    final String parentPath = parentPage.name!;

    for (DevEssentialPage childPage in parentPage.childrens) {
      result.add(_addChild(childPage, parentPath));
      final List<DevEssentialPage> childrens = _flattenPage(childPage);

      for (var child in childrens) {
        result.add(_addChild(
          child,
          parentPath,
        ));
      }
    }
    return result;
  }

  /// Change the Path for a [GetPage]
  DevEssentialPage _addChild(
    DevEssentialPage origin,
    String parentPath,
  ) =>
      origin.copyWith(name: (parentPath + origin.name!).replaceAll(r'//', '/'));

  DevEssentialRouteDecoder matchRoute(
    String name, {
    Object? arguments,
  }) {
    final Uri uri = Uri.parse(name);
    final Map<String, String> params =
        Map<String, String>.from(uri.queryParameters);

    final Iterable<String> splitUriPaths =
        uri.path.split('/').where((element) => element.isNotEmpty);

    String curPath = '/';

    List<String> cumulativePaths = <String>['/'];

    for (var item in splitUriPaths) {
      if (curPath.endsWith('/')) {
        curPath += item;
      } else {
        curPath += '/$item';
      }
      cumulativePaths.add(curPath);
    }

    final List<MapEntry<String, DevEssentialPage>> treeBranch = cumulativePaths
        .map((e) => MapEntry(e, _findRoute(e)))
        .where((element) => element.value != null)
        .map((e) => MapEntry(e.key, e.value!))
        .toList();

    if (treeBranch.isNotEmpty) {
      final MapEntry<String, DevEssentialPage> lastRoute = treeBranch.last;
      final Map<String, String> parsedParams =
          _parseParams(name, lastRoute.value.path);

      if (parsedParams.isNotEmpty) {
        params.addAll(parsedParams);
      }

      final List<DevEssentialPage> mappedTreeBranch = treeBranch
          .map(
            (e) => e.value.copyWith(
              parameters: {
                if (e.value.parameters != null) ...e.value.parameters!,
                ...params,
              },
              name: e.key,
            ),
          )
          .toList();

      return DevEssentialRouteDecoder(
        mappedTreeBranch,
        params,
        arguments,
      );
    }

    //route not found
    return DevEssentialRouteDecoder(
      treeBranch.map((e) => e.value).toList(),
      params,
      arguments,
    );
  }

  DevEssentialPage? _findRoute(String name) {
    return routes.firstWhereOrNull(
      (route) => route.path.regex.hasMatch(name),
    );
  }

  Map<String, String> _parseParams(String path, PathDecoded routePath) {
    final Map<String, String> params = <String, String>{};
    final int idx = path.indexOf('?');
    if (idx > -1) {
      path = path.substring(0, idx);
      final Uri? uri = Uri.tryParse(path);
      if (uri != null) {
        params.addAll(uri.queryParameters);
      }
    }
    final RegExpMatch? paramsMatch = routePath.regex.firstMatch(path);

    for (int i = 0; i < routePath.keys.length; i++) {
      String param = Uri.decodeQueryComponent(paramsMatch![i + 1]!);
      params[routePath.keys[i]!] = param;
    }
    return params;
  }
}
