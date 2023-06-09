part of '../navigation.dart';

typedef DevEssentialPageBuilder = Widget Function(
    BuildContext context, Object? arguments);

class DevEssentialPage extends Page {
  DevEssentialPage({
    LocalKey? key,
    required String name,
    Object? arguments,
    this.parameters,
    required this.builder,
    this.childrens = const [],
  })  : path = _nameToRegex(name),
        assert(name.startsWith('/'),
            'It is necessary to start route name [$name] with a slash: /$name'),
        super(
          key: key ?? ValueKey(name),
          name: name,
          arguments: arguments,
        );

  final PathDecoded path;

  final DevEssentialPageBuilder builder;

  final List<DevEssentialPage> childrens;

  final Map<String, String>? parameters;

  @override
  DevEssentialRoute createRoute(BuildContext context) => DevEssentialRoute(
        name: name!,
        arguments: arguments,
        parameters: parameters,
        pageBuilder: (context) => builder(context, arguments),
      );

  @override
  String toString() =>
      '${objectRuntimeType(this, 'DevEssentialPage')}(name: "$name", arguments: $arguments, parameters:$parameters, path: ${path.regex.pattern})';

  DevEssentialPage copyWith({
    String? name,
    Object? arguments,
    Map<String, String>? parameters,
    DevEssentialPageBuilder? builder,
    List<DevEssentialPage>? childrens,
  }) =>
      DevEssentialPage(
        name: (name ?? this.name)!,
        arguments: arguments ?? this.arguments,
        builder: builder ?? this.builder,
        childrens: childrens ?? this.childrens,
        parameters: parameters ?? this.parameters,
      );

  static PathDecoded _nameToRegex(String path) {
    List<String?> keys = <String?>[];

    String replace(Match pattern) {
      final StringBuffer buffer = StringBuffer('(?:');

      if (pattern[1] != null) buffer.write(r'\.');
      buffer.write('([\\w%+-._~!\$&\'()*,;=:@]+))');
      if (pattern[3] != null) buffer.write('?');

      keys.add(pattern[2]);

      return "$buffer";
    }

    String stringPath = '$path/?'
        .replaceAllMapped(RegExp(r'(\.)?:(\w+)(\?)?'), replace)
        .replaceAll('//', '/');

    return PathDecoded(RegExp('^$stringPath\$'), keys);
  }
}

@immutable
class PathDecoded {
  final RegExp regex;
  final List<String?> keys;
  const PathDecoded(this.regex, this.keys);

  @override
  int get hashCode => regex.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PathDecoded &&
        other.regex == regex; // && listEquals(other.keys, keys);
  }
}
