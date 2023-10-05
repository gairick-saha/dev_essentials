import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../dev_essentials.dart';
import '../hooks/hooks.dart';

part 'src/inherited_dev_essential_root_app.dart';
part 'src/dev_essential_material_app.dart';

abstract class _DevEssentialApp extends HookWidget {
  const _DevEssentialApp({
    Key? key,
    required this.title,
    this.pages,
    this.home,
    this.debugShowCheckedModeBanner = true,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.builder,
    this.navigatorObservers = const [],
    this.splashConfig,
    this.useToastNotification = true,
    this.unknownRoute,
    this.defaultTransition,
    this.defaultTransitionDuration,
    this.defaultTransitionCurve,
    this.defaultDialogTransitionCurve,
    this.defaultDialogTransitionDuration,
    this.customTransition,
    this.showDevicePreview = false,
  })  : assert(
          pages == null || home == null,
          'Either the home property must be specified, '
          'or the pages property need be specified',
        ),
        super(key: key);

  final String title;
  final List<DevEssentialPage>? pages;
  final Widget? home;
  final bool debugShowCheckedModeBanner;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  final TransitionBuilder? builder;
  final List<NavigatorObserver> navigatorObservers;
  final SplashConfig? splashConfig;
  final bool useToastNotification;
  final DevEssentialPage? unknownRoute;
  final DevEssentialTransition? defaultTransition;
  final Duration? defaultTransitionDuration;
  final Curve? defaultTransitionCurve;
  final Curve? defaultDialogTransitionCurve;
  final Duration? defaultDialogTransitionDuration;
  final DevEssentialCustomTransition? customTransition;
  final bool showDevicePreview;

  Route<dynamic> onGenerateRoute(RouteSettings settings);

  List<Route<dynamic>> onGenerateInitialRoutes(String name);

  @override
  Widget build(BuildContext context);
}
