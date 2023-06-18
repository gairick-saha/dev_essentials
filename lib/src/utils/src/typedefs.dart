part of '../utils.dart';

typedef SplashUIBuilder = Widget Function(
  Widget? logo,
  Color? backgroundColor,
);

typedef OnSplashInitCallback = Future<String> Function();

typedef DevEssentialSvg = SvgPicture;

typedef DevEssentialToast = BotToast;
