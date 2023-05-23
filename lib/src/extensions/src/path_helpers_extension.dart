part of '../extensions.dart';

extension PathHelpersExtension on DevEssential {
  static final DevEssentialPathHelper _devEssentialPathHelper =
      DevEssentialPathHelper();

  Future<Directory> tempDirectory() async =>
      await _devEssentialPathHelper.temporaryDirectory();

  Future<Directory> appSupportDirectory() async =>
      await _devEssentialPathHelper.applicationSupportDirectory();

  Future<Directory> libDirectory() async =>
      await _devEssentialPathHelper.libraryDirectory();

  Future<Directory> appDocumentsDirectory() async =>
      await _devEssentialPathHelper.applicationDocumentsDirectory();

  Future<Directory?> externalStorageDirectory() async =>
      await _devEssentialPathHelper.externalStorageDirectory();

  Future<List<Directory>?> externalCacheDirectories() async =>
      await _devEssentialPathHelper.externalCacheDirectories();

  Future<Directory?> downloadsDirectory() async =>
      await _devEssentialPathHelper.downloadsDirectory();

  String basename(String path) => _devEssentialPathHelper.basename(path);

  String basenameWithoutExtension(String path) =>
      _devEssentialPathHelper.basenameWithoutExtension(path);

  String dirname(String path) => _devEssentialPathHelper.dirname(path);

  String extension(String path, [int level = 1]) =>
      _devEssentialPathHelper.extension(path, level);

  String rootPrefix(String path) => _devEssentialPathHelper.rootPrefix(path);

  bool isAbsolute(String path) => _devEssentialPathHelper.isAbsolute(path);

  bool isRelative(String path) => _devEssentialPathHelper.isRelative(path);

  bool isRootRelative(String path) =>
      _devEssentialPathHelper.isRootRelative(path);

  String join(
    String part1, [
    String? part2,
    String? part3,
    String? part4,
    String? part5,
    String? part6,
    String? part7,
    String? part8,
    String? part9,
    String? part10,
    String? part11,
    String? part12,
    String? part13,
    String? part14,
    String? part15,
    String? part16,
  ]) =>
      _devEssentialPathHelper.join(
        part1,
        part2,
        part3,
        part4,
        part5,
        part6,
        part7,
        part8,
        part9,
        part10,
        part11,
        part12,
        part13,
        part14,
        part15,
        part16,
      );

  String joinAll(Iterable<String> parts) =>
      _devEssentialPathHelper.joinAll(parts);

  List<String> split(String path) => _devEssentialPathHelper.split(path);

  String canonicalize(String path) =>
      _devEssentialPathHelper.canonicalize(path);

  String normalize(String path) => _devEssentialPathHelper.normalize(path);

  String relative(String path, {String? from}) =>
      _devEssentialPathHelper.relative(path, from: from);

  bool isWithin(String parent, String child) =>
      _devEssentialPathHelper.isWithin(parent, child);

  bool equals(String path1, String path2) =>
      _devEssentialPathHelper.equals(path1, path2);

  int hash(String path) => _devEssentialPathHelper.hash(path);

  String withoutExtension(String path) =>
      _devEssentialPathHelper.withoutExtension(path);

  String setExtension(String path, String extension) =>
      _devEssentialPathHelper.setExtension(path, extension);

  String fromUri(uri) => _devEssentialPathHelper.fromUri(uri);

  Uri toUri(String path) => _devEssentialPathHelper.toUri(path);

  String prettyUri(uri) => _devEssentialPathHelper.prettyUri(uri);
}
