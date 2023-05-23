part of '../extensions.dart';

extension DeviceAndPackageInfoExtension on DevEssential {
  Future<PackageInfo> getPackageInfo() async =>
      await PackageInfo.fromPlatform();

  Future<Map<String, dynamic>?> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo.data;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.data;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.data;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.data;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsDeviceInfo = await deviceInfo.macOsInfo;
      return macOsDeviceInfo.data;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxDeviceInfo = await deviceInfo.linuxInfo;
      return linuxDeviceInfo.data;
    }

    return null;
  }
}
