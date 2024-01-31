import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../dev_essentials.dart';
import 'hooks/hooks.dart';

abstract class _DevEssentialInterface {
  bool isLogEnable = kDebugMode;

  DevEssentialLogWriterCallback log = defaultLogWriterCallback;

  DevEssentialHookState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedDevEssentialRootApp>()!
      .devEssentialHook;
}

class DevEssential extends _DevEssentialInterface {}

// ignore: non_constant_identifier_names
final DevEssential Dev = DevEssential();

// ignore: non_constant_identifier_names
final DevEssential DEV = Dev;
