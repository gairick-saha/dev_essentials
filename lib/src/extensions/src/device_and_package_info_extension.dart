part of '../extensions.dart';

extension DeviceAndPackageInfoExtension on DevEssential {
  Future<PackageInfo> getPackageInfo() async =>
      await PackageInfo.fromPlatform();

  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  Future<Map<String, dynamic>?> getDeviceInfo() async {
    if (kIsWeb) {
      WebBrowserInfo info = await webBrowserInfo;
      return info.data;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo info = await androidInfo;
      return info.data;
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await iosInfo;
      return info.data;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo info = await windowsInfo;
      return info.data;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo info = await macOsInfo;
      return info.data;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo info = await linuxInfo;
      return info.data;
    }

    return null;
  }

  Future<AndroidDeviceInfo> get androidInfo async =>
      await deviceInfo.androidInfo;

  Future<IosDeviceInfo> get iosInfo async => await deviceInfo.iosInfo;

  Future<WebBrowserInfo> get webBrowserInfo async =>
      await deviceInfo.webBrowserInfo;

  Future<WindowsDeviceInfo> get windowsInfo async =>
      await deviceInfo.windowsInfo;

  Future<MacOsDeviceInfo> get macOsInfo async => await deviceInfo.macOsInfo;

  Future<LinuxDeviceInfo> get linuxInfo async => await deviceInfo.linuxInfo;
}
