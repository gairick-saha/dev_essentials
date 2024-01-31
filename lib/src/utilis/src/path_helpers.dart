part of '../utils.dart';

class DevEssentialPathHelper {
  Future<Directory> temporaryDirectory() async => await getTemporaryDirectory();

  Future<Directory> applicationSupportDirectory() async =>
      await getApplicationSupportDirectory();

  Future<Directory> libraryDirectory() async => await getLibraryDirectory();

  Future<Directory> applicationDocumentsDirectory() async =>
      await getApplicationDocumentsDirectory();

  Future<Directory?> externalStorageDirectory() async =>
      await getExternalStorageDirectory();

  Future<List<Directory>?> externalCacheDirectories() async =>
      await getExternalCacheDirectories();

  Future<Directory?> downloadsDirectory() async =>
      await getDownloadsDirectory();

  String basename(String path) => path_helper.basename(path);

  String basenameWithoutExtension(String path) =>
      path_helper.basenameWithoutExtension(path);

  String dirname(String path) => path_helper.dirname(path);

  String extension(String path, [int level = 1]) =>
      path_helper.extension(path, level);

  String rootPrefix(String path) => path_helper.rootPrefix(path);

  bool isAbsolute(String path) => path_helper.isAbsolute(path);

  bool isRelative(String path) => path_helper.isRelative(path);

  bool isRootRelative(String path) => path_helper.isRootRelative(path);

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
      path_helper.join(
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

  String joinAll(Iterable<String> parts) => path_helper.joinAll(parts);

  List<String> split(String path) => path_helper.split(path);

  String canonicalize(String path) => path_helper.canonicalize(path);

  String normalize(String path) => path_helper.normalize(path);

  String relative(String path, {String? from}) =>
      path_helper.relative(path, from: from);

  bool isWithin(String parent, String child) =>
      path_helper.isWithin(parent, child);

  bool equals(String path1, String path2) => path_helper.equals(path1, path2);

  int hash(String path) => path_helper.hash(path);

  String withoutExtension(String path) => path_helper.withoutExtension(path);

  String setExtension(String path, String extension) =>
      path_helper.setExtension(path, extension);

  String fromUri(uri) => path_helper.fromUri(uri);

  Uri toUri(String path) => path_helper.toUri(path);

  String prettyUri(uri) => path_helper.prettyUri(uri);
}
