part of '../utils.dart';

typedef SplashUIBuilder = Widget Function(
  Widget? logo,
  Color? backgroundColor,
);

typedef OnSplashInitCallback = Future<String> Function(
    BuildContext splashContext);

typedef DevEssentialSvg = SvgPicture;

typedef DevEssentialToast = BotToast;
